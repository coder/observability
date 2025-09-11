<!-- generated: do not edit manually! -->
<!-- see scripts/README.gotmpl -->

# Coder Observability Chart

> [!NOTE]
> This Helm chart is in BETA; use with caution

## Overview

This chart contains a highly opinionated set of integrations between Grafana, Loki, Prometheus, Alertmanager, and
Grafana Agent.

Dashboards, alerts, and runbooks are preconfigured for monitoring [Coder](https://coder.com/) installations.

Out of the box:

Metrics will be scraped from all pods which have a `prometheus.io/scrape=true` annotation.<br>
Logs will be scraped from all pods in the Kubernetes cluster.

## Installation

```bash
helm repo add coder-observability https://helm.coder.com/observability
helm upgrade --install coder-observability coder-observability/coder-observability --version 0.4.1 --namespace coder-observability --create-namespace
```

## Requirements

### General

- Helm 3.7+

### Coder

<details open>
<summary>Kubernetes-based deployments</summary>
  If your installation is not in a namespace named `coder`, you will need to modify:

```yaml
global:
  coder:
    controlPlaneNamespace: <your namespace>
    externalProvisionersNamespace: <your namespace>
```

</details>

<details>
<summary>Non-Kubernetes deployments (click to expand)</summary>
  Ensure your Coder installation is accessible to the resources created by this chart.

Set `global.coder.scrapeMetrics` such that the metrics can be scraped from your installation, e.g.:

```yaml
global:
  coder:
    scrapeMetrics:
      hostname: your.coder.host
      port: 2112
      scrapeInterval: 15s
      additionalLabels:
        job: coder
```

If you would like your logs scraped from a process outside Kubernetes, you need to mount the log file(s) in and
configure Grafana Agent to scrape them; here's an example configuration:

```yaml
grafana-agent:
  agent:
    mounts:
      extra:
        - mountPath: /var/log
          name: logs
          readOnly: true
  controller:
    volumes:
      extra:
        - hostPath:
            path: /var/log
          name: logs

  extraBlocks: |-
    loki.source.file "coder_log" {
      targets    = [
        {__path__ = "/var/log/coder.log", job="coder"},
      ]
      forward_to = [loki.write.loki.receiver]
    }
```

</details>

Ensure these environment variables are set in your Coder deployment:

- `CODER_PROMETHEUS_ENABLE=true`
- `CODER_PROMETHEUS_COLLECT_AGENT_STATS=true`
- `CODER_LOGGING_HUMAN=/dev/stderr` (only `human` log format is supported
  currently; [issue](https://github.com/coder/observability/issues/8))

Ensure these labels exist on your Coder & provisioner deployments:

- `prometheus.io/scrape=true`
- `prometheus.io/port=2112` (ensure this matches the port defined by `CODER_PROMETHEUS_ADDRESS`)

If you use the [`coder/coder` helm chart](https://github.com/coder/coder/tree/main/helm), you can use the
following:

```yaml
coder:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "2112"
```

For more details, see
the [coder documentation on exposing Prometheus metrics](https://coder.com/docs/v2/latest/admin/prometheus).

### Postgres

You may configure the Helm chart to monitor your Coder deployment's Postgres server. Ensure that the resources created
by this Helm chart can access your Postgres server.

Create a secret with your Postgres password and reference it as follows, along with the other connection details:

```yaml
global:
  postgres:
    hostname: <your postgres server host>
    port: <postgres port>
    database: <coder database>
    username: <database username>
    mountSecret: <your secret name here>
```

The secret should be in the form of `PGPASSWORD=<your password>`, as this secret will be used to create an environment
variable.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: pg-secret
  namespace: coder-observability
data:
  PGPASSWORD: <base64-encoded password>
```

<details>
<summary>Postgres metrics (click to expand)</summary>

A tool called [`postgres-exporter`](https://github.com/prometheus-community/postgres_exporter) is used to scrape metrics
from your Postgres server, and you can see the metrics it is exposing as follows:

```bash
kubectl -n coder-observability port-forward statefulset/postgres-exporter 9187

curl http://localhost:9187/metrics
```

</details>

### Grafana

To access Grafana, run:

```bash
kubectl -n coder-observability port-forward svc/grafana 3000:80
```

And open your web browser to http://localhost:3000/.

By default, Grafana is configured to allow anonymous access; if you want password authentication, define this in
your `values.yaml`:

```yaml
grafana:
  admin:
    existingSecret: grafana-admin
    userKey: username
    passwordKey: password
  grafana.ini:
    auth.anonymous:
      enabled: false
```

You will also need to define a secret as follows:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: grafana-admin # this matches the "existingSecret" field above
stringData:
  username: "<your username>" # this matches the "userKey" field above
  password: "<your password>" # this matches the "passwordKey" field above
```

To add an Ingress for Grafana, define this in your `values.yaml`:

```yaml
grafana:
  grafana.ini:
    server:
      domain: observability.example.com
      root_url: "%(protocol)s://%(domain)s/grafana"
      serve_from_sub_path: true
  ingress:
    enabled: true
    hosts:
      - "observability.example.com"
    path: "/"
```

### Prometheus

To access Prometheus, run:

```bash
kubectl -n coder-observability port-forward svc/prometheus 9090:80
```

And open your web browser to http://localhost:9090/graph.

#### Native Histograms

Native histograms are an **experimental** Prometheus feature that remove the need to predefine bucket boundaries and instead provide higher-resolution, adaptive buckets (see [Prometheus docs](https://prometheus.io/docs/specs/native_histograms/) for details).

Unlike classic histograms, which are sent in plain text, **native histograms require the protobuf protocol**.
In addition to running Prometheus with native histogram support, since the Prometheus Helm chart is configured with remote write, the Grafana Agent must be configured to scrape and remote write using protobuf.
Native histograms are **disabled by default**, but when you enable them globally, the Helm chart automatically updates the Grafana Agent configuration accordingly.

To enable native histograms, define this in your `values.yaml`:

```yaml
global:
  telemetry:
    metrics:
      native_histograms: true

prometheus:
  server:
    extraFlags:
      - web.enable-lifecycle
      - enable-feature=remote-write-receiver
      - enable-feature=native-histograms
```

After updating values, it might be required to restart the Grafana Agent so it picks up the new configuration:
```bash
kubectl -n coder-observability rollout restart daemonset/grafana-agent
```

⚠️ **Important**: Classic and native histograms cannot be aggregated together.
If you switch from classic to native histograms, dashboards may need to account for the transition. See [Prometheus migration guidelines](https://prometheus.io/docs/specs/native_histograms/#migration-considerations) for details.

<details>
<summary>Validate Prometheus Native Histograms</summary>

1) Check Prometheus flags:

    Open http://localhost:9090/flags and confirm that `--enable-feature` includes `native-histograms`.

2) Inspect histogram metrics:

   * Classic histograms expose metrics with suffixes: `_bucket`, `_sum`, and `_count`.
   * Native histograms are exposed directly under the metric name.
   * Example: query `coderd_workspace_creation_duration_seconds` in http://localhost:9090/graph.

3) Check Grafana Agent (if remote write is enabled):

   To confirm, run:
    ```bash
    kubectl -n coder-observability port-forward svc/grafana-agent 3030:80
    ```
   Then open http://localhost:3030:
   * scrape configurations defined in `prometheus.scrape.cadvisor`, should have `enable_protobuf_negotiation: true`
   * remote write configurations defined in `prometheus.remote_write.default` should have `send_native_histograms: true`

</details>

## Subcharts

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | grafana | ~v7.3.7 |
| https://grafana.github.io/helm-charts | grafana-agent(grafana-agent) | ~0.37.0 |
| https://grafana.github.io/helm-charts | loki | ~v6.7.3 |
| https://grafana.github.io/helm-charts | pyroscope | ~v1.14.1 |
| https://prometheus-community.github.io/helm-charts | prometheus | ~v25.24.1 |

Each subchart can be disabled by setting the `enabled` field to `false`.

| Subchart        | Setting                 |
|-----------------|-------------------------|
| `grafana`       | `grafana.enabled`       |
| `grafana-agent` | `grafana-agent.enabled` |
| `loki`          | `loki.enabled`          |
| `prometheus`    | `prometheus.enabled`    |

## Values

The `global` values are the values which pertain to this chart, while the rest pertain to the subcharts.
These values represent only the values _set_ in this chart. For the full list of available values, please see each
subchart.

For example, the `grafana.replicas` value is set by this chart by default, and is one of hundreds of available
values which are defined [here](https://github.com/grafana/helm-charts/tree/main/charts/grafana#configuration).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.coder.alerts | object | `{"coderd":{"groups":{"CPU":{"delay":"10m","enabled":true,"period":"10m","thresholds":{"critical":0.9,"warning":0.8}},"IneligiblePrebuilds":{"delay":"10m","enabled":true,"thresholds":{"notify":1}},"Memory":{"delay":"10m","enabled":true,"thresholds":{"critical":0.9,"warning":0.8}},"Replicas":{"delay":"5m","enabled":true,"thresholds":{"critical":1,"notify":3,"warning":2}},"Restarts":{"delay":"1m","enabled":true,"period":"10m","thresholds":{"critical":3,"notify":1,"warning":2}},"UnprovisionedPrebuiltWorkspaces":{"delay":"10m","enabled":true,"thresholds":{"warn":1}},"WorkspaceBuildFailures":{"delay":"10m","enabled":true,"period":"10m","thresholds":{"critical":10,"notify":2,"warning":5}}}},"enterprise":{"groups":{"Licences":{"delay":"1m","enabled":true,"thresholds":{"critical":1,"warning":0.9}}}},"provisionerd":{"groups":{"Replicas":{"delay":"5m","enabled":true,"thresholds":{"critical":1,"notify":3,"warning":2}}}}}` | alerts for the various aspects of Coder |
| global.coder.coderdSelector | string | `"pod=~`coder.*`, pod!~`.*provisioner.*`"` | series selector for Prometheus/Loki to locate provisioner pods. ensure this uses backticks for quotes! |
| global.coder.controlPlaneNamespace | string | `"coder"` | the namespace into which the control plane has been deployed. |
| global.coder.externalProvisionersNamespace | string | `"coder"` | the namespace into which any external provisioners have been deployed. |
| global.coder.logFormat | string | `"human"` |  |
| global.coder.provisionerdSelector | string | `"pod=~`coder-provisioner.*`"` | series selector for Prometheus/Loki to locate provisioner pods. https://coder.com/docs/v2/latest/admin/provisioners TODO: rename container label in provisioner helm chart to be "provisioner" not "coder" ensure this uses backticks for quotes! |
| global.coder.scrapeMetrics | string | `nil` | use this to scrape metrics from a standalone (set of) coder deployment(s) if using kubernetes, rather add an annotation "prometheus.io/scrape=true" and coder will get automatically scraped; set this value to null and configure coderdSelector to target your coder pods |
| global.coder.workspacesSelector | string | `"namespace=`coder-workspaces`"` | the namespace into which any external provisioners have been deployed. |
| global.dashboards | object | `{"queryTimeout":900,"refresh":"30s","timerange":"12h"}` | settings for bundled dashboards |
| global.dashboards.queryTimeout | int | `900` | how long until a query in Grafana will timeout after |
| global.dashboards.refresh | string | `"30s"` | how often dashboards should refresh |
| global.dashboards.timerange | string | `"12h"` | how far back dashboards should look |
| global.externalScheme | string | `"http"` |  |
| global.externalZone | string | `"svc.cluster.local"` |  |
| global.postgres | object | `{"alerts":{"groups":{"Basic":{"delay":"1m","enabled":true},"Connections":{"delay":"5m","enabled":true,"thresholds":{"critical":0.9,"notify":0.5,"warning":0.8}},"Notifications":{"delay":"15m","enabled":true,"thresholds":{"critical":0.9,"notify":0.5,"warning":0.8}}}},"database":"coder","exporter":{"enabled":true,"image":"quay.io/prometheuscommunity/postgres-exporter"},"hostname":"localhost","mountSecret":"secret-postgres","password":null,"port":5432,"sslmode":"disable","sslrootcert":null,"username":"coder","volumeMounts":[],"volumes":[]}` | postgres connection information NOTE: these settings are global so we can parameterise some values which get rendered by subcharts |
| global.postgres.alerts | object | `{"groups":{"Basic":{"delay":"1m","enabled":true},"Connections":{"delay":"5m","enabled":true,"thresholds":{"critical":0.9,"notify":0.5,"warning":0.8}},"Notifications":{"delay":"15m","enabled":true,"thresholds":{"critical":0.9,"notify":0.5,"warning":0.8}}}}` | alerts for postgres |
| global.telemetry | object | `{"metrics":{"native_histograms":false,"scrape_interval":"15s","scrape_timeout":"12s"},"profiling":{"scrape_interval":"60s","scrape_timeout":"70s"}}` | control telemetry collection |
| global.telemetry.metrics | object | `{"native_histograms":false,"scrape_interval":"15s","scrape_timeout":"12s"}` | control metric collection |
| global.telemetry.metrics.native_histograms | bool | `false` | enable Prometheus native histograms or default to classic histograms |
| global.telemetry.metrics.scrape_interval | string | `"15s"` | how often the collector will scrape discovered pods |
| global.telemetry.metrics.scrape_timeout | string | `"12s"` | how long a request will be allowed to wait before being canceled |
| global.telemetry.profiling.scrape_interval | string | `"60s"` | how often the collector will scrape pprof endpoints |
| global.telemetry.profiling.scrape_timeout | string | `"70s"` | how long a request will be allowed to wait before being canceled, must be larger than scrape_interval |
| global.zone | string | `"svc"` |  |
| grafana-agent.agent.clustering.enabled | bool | `true` |  |
| grafana-agent.agent.configMap.create | bool | `false` |  |
| grafana-agent.agent.configMap.key | string | `"config.river"` |  |
| grafana-agent.agent.configMap.name | string | `"collector-config"` |  |
| grafana-agent.agent.extraArgs[0] | string | `"--disable-reporting=true"` |  |
| grafana-agent.agent.mode | string | `"flow"` |  |
| grafana-agent.agent.mounts.dockercontainers | bool | `true` |  |
| grafana-agent.agent.mounts.varlog | bool | `true` |  |
| grafana-agent.commonRelabellings | string | `"rule {\n  source_labels = [\"__meta_kubernetes_namespace\"]\n  target_label  = \"namespace\"\n}\nrule {\n  source_labels = [\"__meta_kubernetes_pod_name\"]\n  target_label  = \"pod\"\n}\n// coalesce the following labels and pick the first value; we'll use this to define the \"job\" label\nrule {\n  source_labels  = [\"__meta_kubernetes_pod_label_app_kubernetes_io_component\", \"app\", \"__meta_kubernetes_pod_container_name\"]\n  separator      = \"/\"\n  target_label   = \"__meta_app\"\n  action         = \"replace\"\n  regex          = \"^/*([^/]+?)(?:/.*)?$\" // split by the delimiter if it exists, we only want the first one\n  replacement    = \"${1}\"\n}\nrule {\n  source_labels = [\"__meta_kubernetes_namespace\", \"__meta_kubernetes_pod_label_app_kubernetes_io_name\", \"__meta_app\"]\n  separator     = \"/\"\n  target_label  = \"job\"\n}\nrule {\n  source_labels = [\"__meta_kubernetes_pod_container_name\"]\n  target_label  = \"container\"\n}\nrule {\n  regex   = \"__meta_kubernetes_pod_label_(statefulset_kubernetes_io_pod_name|controller_revision_hash)\"\n  action  = \"labeldrop\"\n}\nrule {\n  regex   = \"pod_template_generation\"\n  action  = \"labeldrop\"\n}\nrule {\n  source_labels = [\"__meta_kubernetes_pod_phase\"]\n  regex = \"Pending|Succeeded|Failed|Completed\"\n  action = \"drop\"\n}\nrule {\n  source_labels = [\"__meta_kubernetes_pod_node_name\"]\n  action = \"replace\"\n  target_label = \"node\"\n}\nrule {\n  action = \"labelmap\"\n  regex = \"__meta_kubernetes_pod_annotation_prometheus_io_param_(.+)\"\n  replacement = \"__param_$1\"\n}"` |  |
| grafana-agent.controller.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| grafana-agent.controller.type | string | `"daemonset"` |  |
| grafana-agent.crds.create | bool | `false` |  |
| grafana-agent.discovery | string | `"// Discover k8s nodes\ndiscovery.kubernetes \"nodes\" {\n  role = \"node\"\n}\n\n// Discover k8s pods\ndiscovery.kubernetes \"pods\" {\n  role = \"pod\"\n  selectors {\n   role  = \"pod\"\n  }\n}"` |  |
| grafana-agent.enabled | bool | `true` |  |
| grafana-agent.extraBlocks | string | `""` |  |
| grafana-agent.fullnameOverride | string | `"grafana-agent"` |  |
| grafana-agent.podLogsRelabelRules | string | `""` |  |
| grafana-agent.podMetricsRelabelRules | string | `""` |  |
| grafana-agent.withOTLPReceiver | bool | `false` |  |
| grafana."grafana.ini"."auth.anonymous".enabled | bool | `true` |  |
| grafana."grafana.ini"."auth.anonymous".org_name | string | `"Main Org."` |  |
| grafana."grafana.ini"."auth.anonymous".org_role | string | `"Admin"` |  |
| grafana."grafana.ini".analytics.reporting_enabled | bool | `false` |  |
| grafana."grafana.ini".dashboards.default_home_dashboard_path | string | `"/var/lib/grafana/dashboards/coder/0/status.json"` |  |
| grafana."grafana.ini".dataproxy.timeout | string | `"{{ $.Values.global.dashboards.queryTimeout }}"` |  |
| grafana."grafana.ini".feature_toggles.autoMigrateOldPanels | bool | `true` |  |
| grafana."grafana.ini".users.allow_sign_up | bool | `false` |  |
| grafana.admin.existingSecret | string | `""` |  |
| grafana.annotations."prometheus.io/scrape" | string | `"true"` |  |
| grafana.dashboardProviders."coder.yaml".apiVersion | int | `1` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].editable | bool | `false` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].folder | string | `"Coder"` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].name | string | `"coder"` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].options.path | string | `"/var/lib/grafana/dashboards/coder"` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].orgId | int | `1` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].type | string | `"file"` |  |
| grafana.dashboardProviders."coder.yaml".providers[0].updateIntervalSeconds | int | `5` |  |
| grafana.dashboardProviders."infra.yaml".apiVersion | int | `1` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].editable | bool | `false` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].folder | string | `"Infrastructure"` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].name | string | `"infra"` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].options.path | string | `"/var/lib/grafana/dashboards/infra"` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].orgId | int | `1` |  |
| grafana.dashboardProviders."infra.yaml".providers[0].type | string | `"file"` |  |
| grafana.dashboardProviders."sidecar.yaml".apiVersion | int | `1` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].disableDeletion | bool | `false` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].editable | bool | `false` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].folder | string | `"Other"` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].name | string | `"sidecar"` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].options.path | string | `"/tmp/dashboards"` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].orgId | int | `1` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].type | string | `"file"` |  |
| grafana.dashboardProviders."sidecar.yaml".providers[0].updateIntervalSeconds | int | `30` |  |
| grafana.dashboards.infra.node-exporter-full.datasource | string | `"metrics"` |  |
| grafana.dashboards.infra.node-exporter-full.gnetId | int | `1860` |  |
| grafana.dashboards.infra.node-exporter-full.revision | int | `36` |  |
| grafana.dashboards.infra.postgres-database.datasource | string | `"metrics"` |  |
| grafana.dashboards.infra.postgres-database.gnetId | int | `9628` |  |
| grafana.dashboards.infra.postgres-database.revision | int | `7` |  |
| grafana.datasources."datasources.yaml".apiVersion | int | `1` |  |
| grafana.datasources."datasources.yaml".datasources[0].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[0].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[0].isDefault | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[0].name | string | `"pyroscope"` |  |
| grafana.datasources."datasources.yaml".datasources[0].timeout | string | `"{{ add $.Values.global.dashboards.queryTimeout 5 }}"` |  |
| grafana.datasources."datasources.yaml".datasources[0].type | string | `"grafana-pyroscope-datasource"` |  |
| grafana.datasources."datasources.yaml".datasources[0].uid | string | `"pyroscope"` |  |
| grafana.datasources."datasources.yaml".datasources[0].url | string | `"http://pyroscope.{{ .Release.Namespace }}.{{ $.Values.global.zone }}:4040"` |  |
| grafana.datasources."datasources.yaml".datasources[1].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[1].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[1].isDefault | bool | `true` |  |
| grafana.datasources."datasources.yaml".datasources[1].name | string | `"metrics"` |  |
| grafana.datasources."datasources.yaml".datasources[1].timeout | string | `"{{ add $.Values.global.dashboards.queryTimeout 5 }}"` |  |
| grafana.datasources."datasources.yaml".datasources[1].type | string | `"prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[1].uid | string | `"prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[1].url | string | `"http://prometheus.{{ .Release.Namespace }}.{{ $.Values.global.zone }}"` |  |
| grafana.datasources."datasources.yaml".datasources[2].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[2].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[2].isDefault | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[2].name | string | `"logs"` |  |
| grafana.datasources."datasources.yaml".datasources[2].timeout | string | `"{{ add $.Values.global.dashboards.queryTimeout 5 }}"` |  |
| grafana.datasources."datasources.yaml".datasources[2].type | string | `"loki"` |  |
| grafana.datasources."datasources.yaml".datasources[2].uid | string | `"loki"` |  |
| grafana.datasources."datasources.yaml".datasources[2].url | string | `"http://loki-gateway.{{ .Release.Namespace }}.{{ $.Values.global.zone }}"` |  |
| grafana.datasources."datasources.yaml".datasources[3].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[3].isDefault | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[3].jsonData.sslmode | string | `"{{ .Values.global.postgres.sslmode }}"` |  |
| grafana.datasources."datasources.yaml".datasources[3].name | string | `"postgres"` |  |
| grafana.datasources."datasources.yaml".datasources[3].secureJsonData.password | string | `"{{ if .Values.global.postgres.password }}{{ .Values.global.postgres.password }}{{ else }}$PGPASSWORD{{ end }}"` |  |
| grafana.datasources."datasources.yaml".datasources[3].timeout | string | `"{{ add $.Values.global.dashboards.queryTimeout 5 }}"` |  |
| grafana.datasources."datasources.yaml".datasources[3].type | string | `"postgres"` |  |
| grafana.datasources."datasources.yaml".datasources[3].uid | string | `"postgres"` |  |
| grafana.datasources."datasources.yaml".datasources[3].url | string | `"{{ .Values.global.postgres.hostname }}:{{ .Values.global.postgres.port }}"` |  |
| grafana.datasources."datasources.yaml".datasources[3].user | string | `"{{ .Values.global.postgres.username }}"` |  |
| grafana.deploymentStrategy.type | string | `"Recreate"` |  |
| grafana.enabled | bool | `true` |  |
| grafana.env.GF_SECURITY_DISABLE_INITIAL_ADMIN_CREATION | bool | `true` |  |
| grafana.extraConfigmapMounts[0].configMap | string | `"dashboards-status"` |  |
| grafana.extraConfigmapMounts[0].mountPath | string | `"/var/lib/grafana/dashboards/coder/0"` |  |
| grafana.extraConfigmapMounts[0].name | string | `"dashboards-status"` |  |
| grafana.extraConfigmapMounts[0].readOnly | bool | `false` |  |
| grafana.extraConfigmapMounts[1].configMap | string | `"dashboards-coderd"` |  |
| grafana.extraConfigmapMounts[1].mountPath | string | `"/var/lib/grafana/dashboards/coder/1"` |  |
| grafana.extraConfigmapMounts[1].name | string | `"dashboards-coderd"` |  |
| grafana.extraConfigmapMounts[1].readOnly | bool | `false` |  |
| grafana.extraConfigmapMounts[2].configMap | string | `"dashboards-provisionerd"` |  |
| grafana.extraConfigmapMounts[2].mountPath | string | `"/var/lib/grafana/dashboards/coder/2"` |  |
| grafana.extraConfigmapMounts[2].name | string | `"dashboards-provisionerd"` |  |
| grafana.extraConfigmapMounts[2].readOnly | bool | `false` |  |
| grafana.extraConfigmapMounts[3].configMap | string | `"dashboards-workspaces"` |  |
| grafana.extraConfigmapMounts[3].mountPath | string | `"/var/lib/grafana/dashboards/coder/3"` |  |
| grafana.extraConfigmapMounts[3].name | string | `"dashboards-workspaces"` |  |
| grafana.extraConfigmapMounts[3].readOnly | bool | `false` |  |
| grafana.extraConfigmapMounts[4].configMap | string | `"dashboards-workspace-detail"` |  |
| grafana.extraConfigmapMounts[4].mountPath | string | `"/var/lib/grafana/dashboards/coder/4"` |  |
| grafana.extraConfigmapMounts[4].name | string | `"dashboards-workspace-detail"` |  |
| grafana.extraConfigmapMounts[4].readOnly | bool | `false` |  |
| grafana.extraConfigmapMounts[5].configMap | string | `"dashboards-prebuilds"` |  |
| grafana.extraConfigmapMounts[5].mountPath | string | `"/var/lib/grafana/dashboards/coder/5"` |  |
| grafana.extraConfigmapMounts[5].name | string | `"dashboards-prebuilds"` |  |
| grafana.extraConfigmapMounts[5].readOnly | bool | `false` |  |
| grafana.fullnameOverride | string | `"grafana"` |  |
| grafana.image.tag | string | `"10.4.19"` |  |
| grafana.persistence.enabled | bool | `true` |  |
| grafana.persistence.size | string | `"10Gi"` |  |
| grafana.replicas | int | `1` |  |
| grafana.service.enabled | bool | `true` |  |
| grafana.sidecar.dashboards.enabled | bool | `false` |  |
| grafana.sidecar.dashboards.labelValue | string | `"1"` |  |
| grafana.sidecar.dashboards.provider.allowUiUpdates | bool | `true` |  |
| grafana.sidecar.dashboards.provider.disableDelete | bool | `true` |  |
| grafana.testFramework.enabled | bool | `false` |  |
| grafana.useStatefulSet | bool | `true` |  |
| loki.backend.extraArgs[0] | string | `"-log.level=debug"` |  |
| loki.backend.extraVolumeMounts[0].mountPath | string | `"/var/loki-ruler-wal"` |  |
| loki.backend.extraVolumeMounts[0].name | string | `"ruler-wal"` |  |
| loki.backend.extraVolumes[0].emptyDir | object | `{}` |  |
| loki.backend.extraVolumes[0].name | string | `"ruler-wal"` |  |
| loki.backend.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| loki.backend.replicas | int | `1` |  |
| loki.chunksCache.allocatedMemory | int | `1024` |  |
| loki.enabled | bool | `true` |  |
| loki.enterprise.adminApi.enabled | bool | `false` |  |
| loki.enterprise.enabled | bool | `false` |  |
| loki.enterprise.useExternalLicense | bool | `false` |  |
| loki.fullnameOverride | string | `"loki"` |  |
| loki.gateway.replicas | int | `1` |  |
| loki.loki.auth_enabled | bool | `false` |  |
| loki.loki.commonConfig.path_prefix | string | `"/var/loki"` |  |
| loki.loki.commonConfig.replication_factor | int | `1` |  |
| loki.loki.rulerConfig.alertmanager_url | string | `"http://alertmanager.{{ .Release.Namespace }}.{{ .Values.global.zone}}"` |  |
| loki.loki.rulerConfig.enable_alertmanager_v2 | bool | `true` |  |
| loki.loki.rulerConfig.enable_api | bool | `true` |  |
| loki.loki.rulerConfig.remote_write.clients.fake.headers.Source | string | `"Loki"` |  |
| loki.loki.rulerConfig.remote_write.clients.fake.remote_timeout | string | `"30s"` |  |
| loki.loki.rulerConfig.remote_write.clients.fake.url | string | `"http://prometheus.{{ .Release.Namespace }}.{{ .Values.global.zone}}/api/v1/write"` |  |
| loki.loki.rulerConfig.remote_write.enabled | bool | `true` |  |
| loki.loki.rulerConfig.ring.kvstore.store | string | `"inmemory"` |  |
| loki.loki.rulerConfig.rule_path | string | `"/rules"` |  |
| loki.loki.rulerConfig.storage.local.directory | string | `"/rules"` |  |
| loki.loki.rulerConfig.storage.type | string | `"local"` |  |
| loki.loki.rulerConfig.wal.dir | string | `"/var/loki-ruler-wal"` |  |
| loki.loki.schemaConfig.configs[0].from | string | `"2024-04-01"` |  |
| loki.loki.schemaConfig.configs[0].index.period | string | `"24h"` |  |
| loki.loki.schemaConfig.configs[0].index.prefix | string | `"index_"` |  |
| loki.loki.schemaConfig.configs[0].object_store | string | `"s3"` |  |
| loki.loki.schemaConfig.configs[0].schema | string | `"v13"` |  |
| loki.loki.schemaConfig.configs[0].store | string | `"tsdb"` |  |
| loki.lokiCanary.annotations."prometheus.io/scrape" | string | `"true"` |  |
| loki.lokiCanary.enabled | bool | `true` |  |
| loki.minio.address | string | `"loki-storage.{{ .Release.Namespace }}.{{ .Values.global.zone}}:9000"` |  |
| loki.minio.enabled | bool | `true` |  |
| loki.minio.fullnameOverride | string | `"loki-storage"` |  |
| loki.minio.podAnnotations."prometheus.io/path" | string | `"/minio/v2/metrics/cluster"` |  |
| loki.minio.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| loki.minio.podLabels."app.kubernetes.io/name" | string | `"loki-storage"` |  |
| loki.monitoring.dashboards.enabled | bool | `true` |  |
| loki.monitoring.selfMonitoring.enabled | bool | `false` |  |
| loki.monitoring.selfMonitoring.grafanaAgent.installOperator | bool | `false` |  |
| loki.nameOverride | string | `"loki"` |  |
| loki.read.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| loki.read.replicas | int | `1` |  |
| loki.resultsCache.allocatedMemory | int | `1024` |  |
| loki.sidecar.rules.folder | string | `"/rules/fake"` |  |
| loki.sidecar.rules.logLevel | string | `"DEBUG"` |  |
| loki.test.canaryServiceAddress | string | `"http://loki-canary:3500/metrics"` |  |
| loki.test.enabled | bool | `true` |  |
| loki.write.extraArgs[0] | string | `"-log.level=debug"` |  |
| loki.write.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| loki.write.replicas | int | `1` |  |
| prometheus.alertmanager.enabled | bool | `true` |  |
| prometheus.alertmanager.fullnameOverride | string | `"alertmanager"` |  |
| prometheus.alertmanager.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| prometheus.alertmanager.service.port | int | `80` |  |
| prometheus.configmapReload.prometheus.containerPort | int | `9091` |  |
| prometheus.configmapReload.prometheus.extraArgs.log-level | string | `"all"` |  |
| prometheus.configmapReload.prometheus.extraArgs.watch-interval | string | `"15s"` |  |
| prometheus.configmapReload.prometheus.extraConfigmapMounts[0].configMap | string | `"metrics-alerts"` |  |
| prometheus.configmapReload.prometheus.extraConfigmapMounts[0].mountPath | string | `"/etc/config/alerts"` |  |
| prometheus.configmapReload.prometheus.extraConfigmapMounts[0].name | string | `"alerts"` |  |
| prometheus.configmapReload.prometheus.extraConfigmapMounts[0].readonly | bool | `true` |  |
| prometheus.enabled | bool | `true` |  |
| prometheus.kube-state-metrics.enabled | bool | `true` |  |
| prometheus.kube-state-metrics.fullnameOverride | string | `"kube-state-metrics"` |  |
| prometheus.kube-state-metrics.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| prometheus.prometheus-node-exporter.enabled | bool | `true` |  |
| prometheus.prometheus-node-exporter.fullnameOverride | string | `"node-exporter"` |  |
| prometheus.prometheus-node-exporter.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| prometheus.prometheus-pushgateway.enabled | bool | `false` |  |
| prometheus.server.extraArgs."log.level" | string | `"debug"` |  |
| prometheus.server.extraConfigmapMounts[0].configMap | string | `"metrics-alerts"` |  |
| prometheus.server.extraConfigmapMounts[0].mountPath | string | `"/etc/config/alerts"` |  |
| prometheus.server.extraConfigmapMounts[0].name | string | `"alerts"` |  |
| prometheus.server.extraConfigmapMounts[0].readonly | bool | `true` |  |
| prometheus.server.extraFlags[0] | string | `"web.enable-lifecycle"` |  |
| prometheus.server.extraFlags[1] | string | `"enable-feature=remote-write-receiver"` |  |
| prometheus.server.fullnameOverride | string | `"prometheus"` |  |
| prometheus.server.global.evaluation_interval | string | `"30s"` |  |
| prometheus.server.persistentVolume.enabled | bool | `true` |  |
| prometheus.server.persistentVolume.size | string | `"12Gi"` |  |
| prometheus.server.podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| prometheus.server.replicaCount | int | `1` |  |
| prometheus.server.retentionSize | string | `"10GB"` |  |
| prometheus.server.service.type | string | `"ClusterIP"` |  |
| prometheus.server.statefulSet.enabled | bool | `true` |  |
| prometheus.serverFiles."prometheus.yml".rule_files[0] | string | `"/etc/config/alerts/*.yaml"` |  |
| prometheus.serverFiles."prometheus.yml".scrape_configs | list | `[]` |  |
| prometheus.testFramework.enabled | bool | `false` |  |
| pyroscope.alloy.enabled | bool | `false` |  |
| pyroscope.enabled | bool | `false` |  |
| pyroscope.pyroscope.extraArgs."log.level" | string | `"info"` |  |
| pyroscope.pyroscope.fullnameOverride | string | `"pyroscope"` |  |
| pyroscope.pyroscope.persistence.enabled | bool | `true` |  |
| pyroscope.pyroscope.persistence.size | string | `"10Gi"` |  |
| pyroscope.pyroscope.replicaCount | int | `1` |  |
| pyroscope.pyroscope.service.port | int | `4040` |  |
| pyroscope.pyroscope.service.type | string | `"ClusterIP"` |  |
| runbookViewer.image | string | `"dannyben/madness"` |  |
| sqlExporter.enabled | bool | `true` |  |
| sqlExporter.image | string | `"burningalchemist/sql_exporter"` |  |

