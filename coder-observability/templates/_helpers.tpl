{{/*
Expand the name of the chart.
*/}}
{{- define "coder-observability.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "coder-observability.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "coder-observability.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "coder-observability.labels" -}}
helm.sh/chart: {{ include "coder-observability.chart" . }}
{{ include "coder-observability.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "coder-observability.selectorLabels" -}}
app.kubernetes.io/name: {{ include "coder-observability.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "coder-observability.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "coder-observability.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Postgres connector string */}}
{{- define "postgres-connector-string" -}}
{{- if and .Values.global.postgres.password (eq .Values.global.postgres.sslmode "disable") -}}
postgresql://{{ .Values.global.postgres.username }}:{{ urlquery .Values.global.postgres.password }}@{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}/{{ .Values.global.postgres.database }}?sslmode={{ .Values.global.postgres.sslmode }}
{{- else if and .Values.global.postgres.password (ne .Values.global.postgres.sslmode "disable") -}}
postgresql://{{ .Values.global.postgres.username }}:{{ urlquery .Values.global.postgres.password }}@{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}/{{ .Values.global.postgres.database }}?sslmode={{ .Values.global.postgres.sslmode }}&sslrootcert={{ .Values.global.postgres.sslrootcert }}
{{- else if and .Values.global.postgres.mountSecret (eq .Values.global.postgres.sslmode "disable") -}}
postgresql://{{ .Values.global.postgres.username }}@{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}/{{ .Values.global.postgres.database }}?sslmode={{ .Values.global.postgres.sslmode }}
{{- else if and .Values.global.postgres.mountSecret (ne .Values.global.postgres.sslmode "disable") -}}
postgresql://{{ .Values.global.postgres.username }}@{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}/{{ .Values.global.postgres.database }}?sslmode={{ .Values.global.postgres.sslmode }}&sslrootcert={{ .Values.global.postgres.sslrootcert }}
{{- else -}}
{{ fail "either postgres.password or postgres.mountSecret must be defined" }}
{{- end -}}
{{- end }}

{{/* Postgres connector string */}}
{{- define "postgres-secret-mount" -}}
{{ if .Values.global.postgres.mountSecret }}
envFrom:
  - secretRef:
      name: {{ .Values.global.postgres.mountSecret }}
{{ end }}
{{- end }}

{{/* Postgres Exporter does not export a pubsub usage metric by default, so we add one */}}
{{- define "postgres-pubsub-queue-usage-metric-name" -}}pg_pubsub_usage{{- end }}

{{/* Build a runbook URL */}}
{{- define "runbook-url" -}}
{{ $outer := . }}
{{- with .Values.global -}}
  {{- .externalScheme }}://runbook-viewer.{{ $outer.Release.Namespace }}.{{ .externalZone }}/{{- $outer.service }}#{{- $outer.alert | lower }}
{{- end }}
{{- end }}

{{- define "coderd-selector" -}} {{- printf "%s, namespace=`%s`" .Values.global.coder.coderdSelector .Values.global.coder.controlPlaneNamespace -}} {{- end }}
{{- define "provisionerd-selector" -}} {{- printf "%s, namespace=`%s`" .Values.global.coder.provisionerdSelector .Values.global.coder.externalProvisionersNamespace -}} {{- end }}
{{- define "workspaces-selector" -}} {{- .Values.global.coder.workspacesSelector -}} {{- end }}
{{- define "non-workspace-selector" -}} {{- printf "namespace=~`(%s|%s)`" (include "control-plane-namespace" .) (include "external-provisioners-namespace" .) -}} {{- end }}
{{- define "control-plane-namespace" -}} {{- .Values.global.coder.controlPlaneNamespace -}} {{- end }}
{{- define "external-provisioners-namespace" -}} {{- .Values.global.coder.externalProvisionersNamespace -}} {{- end }}

{{/* The collector creates "job" labels in the form <namespace>/<component>/<container> */}}

{{/* Prometheus job label */}}
{{- define "prometheus-job" -}} {{- printf "%s/%s/%s" .Release.Namespace .Values.prometheus.server.fullnameOverride .Values.prometheus.server.name -}} {{- end }}
{{/* Loki job label */}}
{{- define "loki-job" -}} {{- printf "%s/%s" .Release.Namespace .Values.loki.fullnameOverride -}} {{- end }}
{{/* Grafana Agent job label */}}
{{- define "grafana-agent-job" -}} {{- printf "%s/%s/%s" .Release.Namespace (index .Values "grafana-agent").fullnameOverride "grafana-agent" -}} {{- end }}

{{- define "dashboard-range" -}} {{ .Values.global.dashboards.timerange }} {{- end }}
{{- define "dashboard-refresh" -}} {{ .Values.global.dashboards.refresh }} {{- end }}