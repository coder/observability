{{- define "collector-config" -}}
{{ $agent := (index .Values "grafana-agent") }}

{{ $agent.logging }}
{{ $agent.discovery }}

discovery.relabel "pod_logs" {
  targets = discovery.kubernetes.pods.targets
  {{ $agent.commonRelabellings | nindent 2 }}
  rule {
    source_labels = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
    separator     = "/"
    action        = "replace"
    replacement   = "/var/log/pods/*$1/*.log"
    target_label  = "__path__"
  }
  rule {
    action = "replace"
    source_labels = ["__meta_kubernetes_pod_container_id"]
    regex = "^(\\w+):\\/\\/.+$"
    replacement = "$1"
    target_label = "tmp_container_runtime"
  }
  {{- if $agent.podLogsRelabelRules -}}
  {{ $agent.podLogsRelabelRules | trim | nindent 2 }}
  {{- end }}
}

discovery.relabel "pod_metrics" {
  targets = discovery.kubernetes.pods.targets
  {{ $agent.commonRelabellings | nindent 6 }}
  // drop ports that do not expose Prometheus metrics, but might otherwise be exposed by a container which *also*
  // exposes an HTTP port which exposes metrics
  rule {
    source_labels = ["__meta_kubernetes_pod_container_port_name"]
    regex         = "grpc|http-(memberlist|console)"
    action        = "drop"
  }
  // adapted from the Prometheus helm chart
  // https://github.com/prometheus-community/helm-charts/blob/862870fc3c847e32479b509e511584d5283126a3/charts/prometheus/values.yaml#L1070
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_scrape"]
    action = "keep"
    regex = "true"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_scheme"]
    action = "replace"
    regex = "(https?)"
    target_label = "__scheme__"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_path"]
    action = "replace"
    target_label = "__metrics_path__"
    regex = "(.+)"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
    action = "replace"
    regex = "(\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})"
    replacement = "[$2]:$1"
    target_label = "__address__"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
    action = "replace"
    regex = "(\\d+);((([0-9]+?)(\\.|$)){4})"
    replacement = "$2:$1"
    target_label = "__address__"
  }
  {{- if $agent.podMetricsRelabelRules -}}
  {{ $agent.podMetricsRelabelRules | trim | nindent 2 }}
  {{- end }}
}

discovery.relabel "pod_pprof" {
  targets = discovery.kubernetes.pods.targets
  {{ $agent.commonRelabellings | nindent 6 }}
  // The relabeling allows the actual pod scrape endpoint to be configured via the
  // following annotations:
  //
  // * `pyroscope.io/scrape`: Only scrape pods that have a value of `true`.
  // * `pyroscope.io/application-name`: Name of the application being profiled.
  // * `pyroscope.io/scheme`: If the metrics endpoint is secured then you will need
  // to set this to `https` & most likely set the `tls_config` of the scrape config.
  // * `pyroscope.io/port`: Scrape the pod on the indicated port.
  //
  // Kubernetes labels will be added as Pyroscope labels on metrics via the
  // `labelmap` relabeling action.
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_pyroscope_io_scrape"]
    action = "keep"
    regex = "true"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_pyroscope_io_application_name"]
    action = "replace"
    target_label = "__name__"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_pyroscope_io_scheme"]
    action = "replace"
    regex = "(https?)"
    target_label = "__scheme__"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_pyroscope_io_port", "__meta_kubernetes_pod_ip"]
    action = "replace"
    regex = "(\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})"
    replacement = "[$2]:$1"
    target_label = "__address__"
  }
  rule {
    source_labels = ["__meta_kubernetes_pod_annotation_pyroscope_io_port", "__meta_kubernetes_pod_ip"]
    action = "replace"
    regex = "(\\d+);((([0-9]+?)(\\.|$)){4})"
    replacement = "$2:$1"
    target_label = "__address__"
  }
  {{- if $agent.podMetricsRelabelRules -}}
  {{ $agent.podMetricsRelabelRules | trim | nindent 2 }}
  {{- end }}
}

local.file_match "pod_logs" {
  path_targets = discovery.relabel.pod_logs.output
}

loki.source.file "pod_logs" {
  targets    = local.file_match.pod_logs.targets
  forward_to = [loki.process.pod_logs.receiver]
}

loki.process "pod_logs" {
  stage.match {
    selector = "{tmp_container_runtime=\"containerd\"}"
    // the cri processing stage extracts the following k/v pairs: log, stream, time, flags
    stage.cri {}
    // Set the extract flags and stream values as labels
    stage.labels {
      values = {
        flags   = "",
        stream  = "",
      }
    }
  }

  // if the label tmp_container_runtime from above is docker parse using docker
  stage.match {
    selector = "{tmp_container_runtime=\"docker\"}"
    // the docker processing stage extracts the following k/v pairs: log, stream, time
    stage.docker {}

    // Set the extract stream value as a label
    stage.labels {
      values = {
        stream  = "",
      }
    }
  }

  // drop the temporary container runtime label as it is no longer needed
  stage.label_drop {
    values = ["tmp_container_runtime"]
  }

  // parse Coder logs and extract level & logger for efficient filtering
  stage.match {
    selector = "{pod=~\"coder.*\"}" // TODO: make configurable

    stage.multiline {
      firstline     = {{ printf `^(?P<ts>\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})` | quote }}
      max_wait_time = "10s"
    }

    stage.regex {
      expression = {{ printf `^(?P<ts>\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})\s\[(?P<level>\w+)\]\s\s(?P<logger>[^:]+):\s(?P<line>.+)` | quote }}
    }

    stage.timestamp {
      source            = "ts"
      format            = "2006-01-02 15:04:05.000"
      action_on_failure = "fudge" // rather have inaccurate time than drop the log line
    }

    stage.labels {
      values = {
        level  = "",
        logger = "",
      }
    }
  }

  forward_to = [loki.write.loki.receiver]
}
{{ if $agent.extraBlocks -}}
{{ $agent.extraBlocks }}
{{- end }}
loki.write "loki" {
  endpoint {
    url = "http://{{ include "loki.fullname" .Subcharts.loki }}-gateway.{{ .Release.Namespace }}.{{ .Values.global.zone }}/loki/api/v1/push"
  }
}

pyroscope.scrape "pods" {
  targets = discovery.relabel.pod_pprof.output
  forward_to = [pyroscope.write.pods.receiver]

  scrape_interval = "{{ .Values.global.telemetry.profiling.scrape_interval }}"
  scrape_timeout = "{{ .Values.global.telemetry.profiling.scrape_timeout }}"
}

pyroscope.write "pods" {
  endpoint {
    url = "http://{{ include "pyroscope.fullname" .Subcharts.pyroscope }}.{{ .Release.Namespace }}.{{ .Values.global.zone }}:{{ .Values.pyroscope.pyroscope.service.port }}"
  }
}

prometheus.scrape "pods" {
  targets = discovery.relabel.pod_metrics.output
  forward_to = [prometheus.relabel.pods.receiver]

  scrape_interval = "{{ .Values.global.telemetry.metrics.scrape_interval }}"
  scrape_timeout = "{{ .Values.global.telemetry.metrics.scrape_timeout }}"
}

// These are metric_relabel_configs while discovery.relabel are relabel_configs.
// See https://github.com/grafana/agent/blob/main/internal/converter/internal/prometheusconvert/prometheusconvert.go#L95-L106
prometheus.relabel "pods" {
  forward_to = [prometheus.remote_write.default.receiver]

  // Drop kube-state-metrics' labels which clash with ours
  rule {
    source_labels = ["__name__", "container"]
    regex         = "kube_pod.+;(.+)"
    target_label  = "container"
    replacement   = ""
  }
  rule {
    source_labels = ["__name__", "pod"]
    regex         = "kube_pod.+;(.+)"
    target_label  = "pod"
    replacement   = ""
  }
  rule {
    source_labels = ["__name__", "namespace"]
    regex         = "kube_pod.+;(.+)"
    target_label  = "namespace"
    replacement   = ""
  }
  rule {
    source_labels = ["__name__", "exported_container"]
    // don't replace an empty label
    regex         = "^kube_pod.+;(.+)$"
    target_label  = "container"
    replacement   = "$1"
  }
  rule {
    source_labels = ["__name__", "exported_pod"]
    // don't replace an empty label
    regex         = "^kube_pod.+;(.+)$"
    target_label  = "pod"
    replacement   = "$1"
  }
  rule {
    source_labels = ["__name__", "exported_namespace"]
    // don't replace an empty label
    regex         = "^kube_pod.+;(.+)$"
    target_label  = "namespace"
    replacement   = "$1"
  }
  rule {
    regex         = "^(exported_.*|image_.*|container_id|id|uid)$"
    action        = "labeldrop"
  }
}

discovery.relabel "cadvisor" {
  targets = discovery.kubernetes.nodes.targets
  rule {
    replacement   = "/metrics/cadvisor"
    target_label  = "__metrics_path__"
  }
}

prometheus.scrape "cadvisor" {
  targets    = discovery.relabel.cadvisor.output
  forward_to = [ prometheus.relabel.cadvisor.receiver ]
  scheme     = "https"
  tls_config {
    insecure_skip_verify = true
  }
  bearer_token_file = "/var/run/secrets/kubernetes.io/serviceaccount/token"
  scrape_interval   = "{{ .Values.global.telemetry.metrics.scrape_interval }}"
  scrape_timeout    = "{{ .Values.global.telemetry.metrics.scrape_timeout }}"
}

prometheus.relabel "cadvisor" {
  forward_to = [ prometheus.remote_write.default.receiver ]

  // Drop empty container labels, addressing https://github.com/google/cadvisor/issues/2688
  rule {
    source_labels = ["__name__","container"]
    separator = "@"
    regex = "(container_cpu_.*|container_fs_.*|container_memory_.*)@"
    action = "drop"
  }
  // Drop empty image labels, addressing https://github.com/google/cadvisor/issues/2688
  rule {
    source_labels = ["__name__","image"]
    separator = "@"
    regex = "(container_cpu_.*|container_fs_.*|container_memory_.*|container_network_.*)@"
    action = "drop"
  }
  // Drop irrelevant series
  rule {
    source_labels = ["container"]
    regex         = "^POD$"
    action        = "drop"
  }
  // Drop unnecessary labels
  rule {
    source_labels = ["id"]
    target_label  = "id"
    replacement   = ""
  }
  rule {
    source_labels = ["job"]
    target_label  = "job"
    replacement   = ""
  }
  rule {
    source_labels = ["name"]
    target_label  = "name"
    replacement   = ""
  }
}

prometheus.remote_write "default" {
  endpoint {
    url ="http://{{ include "prometheus.server.fullname" .Subcharts.prometheus }}.{{ .Release.Namespace }}.{{ .Values.global.zone }}/api/v1/write"

    // drop instance label which unnecessarily adds new series when pods are restarted, since pod IPs are dynamically assigned
    // NOTE: "__address__" is mapped to "instance", so will contain <hostname>:<port>
    write_relabel_config {
      regex  = "instance"
      action = "labeldrop"
    }
  }
}

{{- if $agent.withOTLPReceiver -}}
otelcol.receiver.otlp "otlp_receiver" {
  grpc {
    endpoint = "0.0.0.0:4317"
  }
  http {
    endpoint = "0.0.0.0:4318"
  }
  output {
    metrics = [otelcol.processor.batch.default.input]
    logs = [otelcol.processor.batch.default.input]
  }
}
otelcol.exporter.prometheus "to_prometheus" {
  forward_to = [
    prometheus.remote_write.default.receiver,
  ]
}
otelcol.exporter.loki "to_loki" {
  forward_to = [
    loki.write.loki.receiver,
  ]
}
otelcol.processor.batch "default" {
  output {
    metrics = [otelcol.exporter.prometheus.to_prometheus.input]
    logs    = [otelcol.exporter.loki.to_loki.input]
  }
}
{{- end -}}

{{ with .Values.global.coder.scrapeMetrics }}
prometheus.scrape "coder_metrics" {
  targets = [
    {"__address__" = "{{ .hostname }}:{{ .port }}", {{ include "collector-labels" .additionalLabels | trimSuffix "," }}},
  ]

  forward_to = [prometheus.remote_write.default.receiver]
  scrape_interval = "{{ .scrapeInterval }}"
}
{{- end }}
{{- end }}

{{- define "collector-labels" -}}
{{- range $key, $val := . -}}
{{ $key }} = "{{ $val }}",
{{- end -}}
{{ end }}