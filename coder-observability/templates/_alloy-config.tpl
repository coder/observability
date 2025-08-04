{{- define "alloy-config" -}}
{{- $alloy := .Values.alloy }}
{{- $pyroscope := .Values.pyroscope }}
{{- $coder := .Values.global.coder }}

// Logging configuration
logging {
  level  = "info"
  format = "logfmt"
}

// Discovery for Coder pods
discovery.kubernetes "coder_pods" {
  role = "pod"
  namespaces {
    names = ["{{ .Values.global.coder.controlPlaneNamespace }}"]
  }
}

// Relabel rules to find Coder pods with pprof enabled
discovery.relabel "coder_pprof" {
  targets = discovery.kubernetes.coder_pods.targets
  
  // Keep only pods that match the coder selector
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    regex         = "coder.*"
    action        = "keep"
  }
  
  // Skip provisioner pods
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    regex         = ".*provisioner.*"
    action        = "drop"
  }
  
  // Set the pprof port and path
  rule {
    target_label = "__address__"
    replacement  = "${1}:{{ .Values.global.coder.pprofPort | default "6060" }}"
    source_labels = ["__meta_kubernetes_pod_ip"]
  }
  
  // Add service label
  rule {
    target_label = "service_name"
    replacement  = "coder"
  }
  
  // Add pod name as instance
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    target_label  = "instance"
  }
  
  // Add namespace
  rule {
    source_labels = ["__meta_kubernetes_namespace"]
    target_label  = "namespace"
  }
}

// Scrape pprof profiles
pyroscope.scrape "coder_profiles" {
  targets    = discovery.relabel.coder_pprof.output
  forward_to = [pyroscope.write.pyroscope.receiver]
  
  profiling_config {
    profile.process_cpu {
      enabled = true
      path    = "/debug/pprof/profile"
      delta   = false
    }
    
    profile.memory {
      enabled = true
      path    = "/debug/pprof/heap"
      delta   = false
    }
    
    profile.goroutine {
      enabled = true
      path    = "/debug/pprof/goroutine"
      delta   = false
    }
    
    profile.block {
      enabled = true
      path    = "/debug/pprof/block"
      delta   = true
    }
    
    profile.mutex {
      enabled = true
      path    = "/debug/pprof/mutex"
      delta   = true
    }
  }
  
  scrape_interval = "15s"
  scrape_timeout  = "10s"
}

// Write profiles to Pyroscope
pyroscope.write "pyroscope" {
  endpoint {
    url = "http://{{ .Values.pyroscope.fullnameOverride }}:{{ .Values.pyroscope.service.port }}"
  }
}
{{- end }}