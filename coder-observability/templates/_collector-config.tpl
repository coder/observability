{{- define "collector-config" -}}
{{ .Values.collector.logging }}
{{ .Values.collector.discovery }}

discovery.relabel "pod_logs" {
  targets = discovery.kubernetes.pods.targets
  {{ .Values.collector.commonRelabellings | nindent 2 }}
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
  {{- if .Values.collector.podLogsRelabelRules -}}
  {{ .Values.collector.podLogsRelabelRules | trim | nindent 2 }}
  {{- end }}
}

discovery.relabel "pod_metrics" {
  targets = discovery.kubernetes.pods.targets
  {{ .Values.collector.commonRelabellings | nindent 6 }}
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
  {{- if .Values.collector.podMetricsRelabelRules -}}
  {{ .Values.collector.podMetricsRelabelRules | trim | nindent 2 }}
  {{- end }}
}

local.file_match "pod_logs" {
  path_targets = discovery.relabel.pod_logs.output
}

loki.source.file "pod_logs" {
  targets    = local.file_match.pod_logs.targets
  forward_to = [loki.process.pod_logs.receiver]
}

// basic processing to parse the container format. You can add additional processing stages
// to match your application logs.
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

  forward_to = [loki.write.loki.receiver]
}
{{ if .Values.collector.extraBlocks -}}
{{ .Values.collector.extraBlocks }}
{{- end }}
loki.write "loki" {
  endpoint {
    url = "http://{{ include "loki.fullname" .Subcharts.logs }}-gateway.{{ .Release.Namespace }}.svc/loki/api/v1/push"
  }
}

prometheus.scrape "pods" {
  targets = discovery.relabel.pod_metrics.output
  forward_to = [prometheus.remote_write.default.receiver]
  scrape_interval = "{{ .Values.global.metrics.scrape_interval }}"
  scrape_timeout = "{{ .Values.global.metrics.scrape_timeout }}"
}

prometheus.remote_write "default" {
  endpoint {
    url ="http://{{ include "prometheus.server.fullname" .Subcharts.metrics }}.{{ .Release.Namespace }}.svc/api/v1/write"

    // drop instance label which unnecessarily adds new series when pods are restarted, since pod IPs are dynamically assigned
    // NOTE: "__address__" is mapped to "instance", so will contain <hostname>:<port>
    write_relabel_config {
      regex  = "instance"
      action = "labeldrop"
    }
  }
}

{{- if .Values.collector.withOTLPReceiver -}}
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