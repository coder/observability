{{/*
Log-based alerting rules, evaluated by the Loki ruler (LogQL, not PromQL).
See https://grafana.com/docs/loki/latest/alert/
*/}}
{{- define "coderd-loki-alerts" -}}
  {{- $service := dict "service" "coderd" -}}
  {{- with .Values.global.coder.alerts.coderd }}
  {{- with .groups.Panics }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Panics
      rules:
      {{ $alert := "CoderdPanic" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        # Panic and fatal-error output is untimestamped, so the collector's multiline
        # stage appends it to the preceding timestamped log entry; (?m) lets ^ match
        # the start of the embedded panic line. "panic serving http request" is logged
        # by coderd when it recovers a panic in an HTTP handler. aibridge loggers echo
        # LLM chat content, which can quote Go tracebacks pasted by users, and are
        # excluded.
        expr: |
          sum by (namespace, pod) (
            count_over_time(
              { {{- include "coderd-selector" $ -}}, logger!~`coderd\.aibridge.*` }
                |~ `(?m)^(panic|fatal error): |panic serving http request` [{{ $group.period }}]
            )
          ) > {{ $threshold }}
        annotations:
          summary: The Coder instance {{ `{{ $labels.pod }}` }} logged a panic in the last {{ $group.period }}.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
{{- end }}
