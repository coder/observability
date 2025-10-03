{{- define "coderd-prometheus-alerts" -}}
  {{- $service := dict "service" "coderd" -}}
  {{- with .Values.global.coder.alerts.coderd }}
  {{- with .groups.CPU }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: CPU Usage
      rules:
      {{ $alert := "CoderdCPUUsage" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: max by (pod) (rate(container_cpu_usage_seconds_total{ {{- include "coderd-selector" $ -}} }[{{- $group.period -}}])) / max by(pod) (kube_pod_container_resource_limits{ {{- include "coderd-selector" $ -}}, resource="cpu"}) > {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: The Coder instance {{ `{{ $labels.pod }}` }} is using high amounts of CPU, which may impact application performance.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.Memory }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Memory Usage
      rules:
      {{ $alert := "CoderdMemoryUsage" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: max by (pod) (container_memory_working_set_bytes{ {{- include "coderd-selector" $ -}} }) / max by (pod) (kube_pod_container_resource_limits{ {{- include "coderd-selector" $ -}}, resource="memory"})  > {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: The Coder instance {{ `{{ $labels.pod }}` }} is using high amounts of memory, which may lead to an Out-Of-Memory (OOM) error.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.Restarts }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Pod Restarts
      rules:
      {{ $alert := "CoderdRestarts" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: sum by(pod) (increase(kube_pod_container_status_restarts_total{ {{- include "coderd-selector" $ -}} }[{{- $group.period -}}])) > {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: The Coder instance {{ `{{ $labels.pod }}` }} has restarted multiple times in the last {{ $group.period -}}, which may indicate a CrashLoop.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.Replicas }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Coderd Replicas
      rules:
      {{ $alert := "CoderdReplicas" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: sum(up{ {{- include "coderd-selector" $ -}} }) < {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: Number of alive coderd replicas is below the threshold = {{ $threshold -}}.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.WorkspaceBuildFailures }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Coderd Workspace Build Failures
      rules:
      {{ $alert := "CoderdWorkspaceBuildFailures" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: sum(increase(coderd_workspace_builds_total{ {{- include "coderd-selector" $ -}} , status="failed" }[{{- $group.period -}}])) > {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: Workspace builds have failed multiple times in the last {{ $group.period -}}, which may indicate a broken Coder template.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.IneligiblePrebuilds }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Coderd Ineligible Prebuilds
      rules:
      {{ $alert := "CoderdIneligiblePrebuilds" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: max by (template_name, preset_name) (coderd_prebuilt_workspaces_running - coderd_prebuilt_workspaces_eligible) > 0
        for: {{ $group.delay }}
        annotations:
          summary: >
            {{ `{{ $value }}` }} prebuilt workspace(s) are currently ineligible for claiming for the "{{ `{{ $labels.template_name }}` }}" template and "{{ `{{ $labels.preset_name }}` }}" preset.
            This usually indicates that the agent has not started correctly, or is still running its startup scripts after an extended period of time.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- with .groups.UnprovisionedPrebuiltWorkspaces }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Coderd Unprovisioned Prebuilt Workspaces
      rules:
      {{ $alert := "CoderdUnprovisionedPrebuiltWorkspaces" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: max by (template_name, preset_name) (coderd_prebuilt_workspaces_desired - coderd_prebuilt_workspaces_running) > 0
        for: {{ $group.delay }}
        annotations:
          summary: >
            {{ `{{ $value }}` }} prebuilt workspace(s) not yet been provisioned for the "{{ `{{ $labels.template_name }}` }}" template and "{{ `{{ $labels.preset_name }}` }}" preset.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- end }}
{{- end }}

{{- define "provisionerd-prometheus-alerts" -}}
  {{- $service := dict "service" "coderd" -}}
  {{- with .Values.global.coder.alerts.provisionerd }}
  {{- with .groups.Replicas }}
  {{- $group := . }}
  {{- if .enabled }}
    - name: Provisionerd Replicas
      rules:
      {{ $alert := "ProvisionerdReplicas" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: sum(coderd_provisionerd_num_daemons{ {{- include "coderd-selector" $ -}} }) < {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: Number of alive provisionerd replicas is below the threshold = {{ $threshold -}}.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end }}
  {{- end }}

  {{- end }}
{{- end }}

{{- define "enterprise-prometheus-alerts" -}}
  {{- $service := dict "service" "enterprise" -}}

  {{- with .Values.global.coder.alerts.enterprise }}
  {{- with .groups.Licences }}
  {{- $group := . }}
    {{- if .enabled }}
      - name: Licences
        rules:
      {{ $alert := "CoderLicenseSeats" }}
      {{- range $severity, $threshold := .thresholds }}
          - alert: {{ $alert }}
            expr: 'max(coderd_license_active_users) / max(coderd_license_limit_users) >= {{- $threshold }}'
            for: {{ $group.delay }}
            annotations:
              summary: Your Coder enterprise licence usage is now at {{ `{{ $value | humanizePercentage }}` }} capacity.
            labels:
              severity: {{ $severity }}
              runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- end }}
{{- end }}

{{- define "postgres-prometheus-alerts" -}}
  {{- $service := dict "service" "postgres" -}}
  {{- with .Values.global.postgres }}
  {{- with .alerts.groups.Notifications }}
  {{- $group := . -}}
  {{- if .enabled }}
    - name: Notifications
      rules:
      {{ $alert := "PostgresNotificationQueueFillingUp" }}
      {{- range $severity, $threshold := .thresholds }}
      - alert: {{ $alert }}
        expr: {{ include "postgres-pubsub-queue-usage-metric-name" . }} > {{ $threshold }}
        for: {{ $group.delay }}
        annotations:
          summary: The postgres instance {{ `{{ $labels.instance }}` }} has a notification that is filling up, which may impact application performance.
        labels:
          severity: {{ $severity }}
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end -}}
  {{- end -}}
  {{- with .alerts.groups.Basic }}
  {{ $group := . -}}
  {{- if .enabled }}
    - name: Liveness
      rules:
      {{ $alert := "PostgresDown" }}
      - alert: {{ $alert }}
        expr: pg_up == 0
        for: {{ $group.delay }}
        annotations:
          summary: The postgres instance {{ `{{ $labels.instance }}` }} is down!
        labels:
          severity: critical
          runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{ end }}
  {{- with .alerts.groups.Connections }}
  {{ $group := . -}}
  {{- if .enabled }}
    - name: Connections
      rules:
      {{ $alert := "PostgresConnectionsRunningLow" }}
      {{- range $severity, $threshold := .thresholds }}
        - alert: {{ $alert }}
          expr: sum by (datname, instance) (pg_stat_activity_count) > on () group_left() (pg_settings_max_connections * {{ $threshold }})
          for: {{ $group.delay }}
          labels:
            summary: The postgres instance {{ `{{ $labels.instance }}` }} is running low on connections which may impact application performance.
            severity: {{ $severity }}
            runbook_url: {{ template "runbook-url" (deepCopy $ | merge (dict "alert" $alert) $service) }}
      {{- end }}
  {{- end -}}
  {{- end -}}
  {{ end }}
{{- end }}
