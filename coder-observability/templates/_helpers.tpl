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

{{/*
Create the name of the service account to use
*/}}
{{- define "coder-observability.datasources" -}}
apiVersion: 1
datasources:
  - name: prometheus
    type: prometheus
    url: http://prometheus-server.monitoring.svc.cluster.local
    access: proxy
    isDefault: true
    editable: false
  - name: loki
    type: loki
    url: http://loki-gateway.monitoring.svc.cluster.local
    access: proxy
    isDefault: false
    editable: false
{{- end }}

{{/*
Postgres connector string
*/}}
{{- define "postgres-connector-string" -}}
postgresql://{{ .Values.global.postgres.username }}:{{ .Values.global.postgres.password }}@{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}/postgres?sslmode={{ .Values.global.postgres.sslmode }}
{{- end }}

{{/* Postgres Exporter does not export a pubsub usage metric by default, so we add one */}}
{{- define "postgres-pubsub-queue-usage-metric-name" -}}pg_pubsub_usage{{- end }}

