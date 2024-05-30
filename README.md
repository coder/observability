# Coder Observability Chart

**<span style="color:orange;">**NOTE:** this Helm chart is in BETA; use with caution.</span>**

## Overview

This chart contains a highly opinionated set of integrations between Grafana, Loki, Prometheus, Alertmanager, and
Grafana Agent.

Dashboards, alerts, and runbooks are preconfigured for monitoring [Coder](https://coder.com/) installations.

Out of the box:

Metrics will be scraped from all pods which have a `prometheus.io/scrape=true` annotation.<br>
Logs will be scraped from all pods in the Kubernetes cluster.

## Installation

<!-- TODO: auto-update version here from publish script -->

```bash
helm repo add coder-observability https://helm.coder.com/observability
helm upgrade --install coder-observability coder-observability/coder-observability --version 0.1.1 --namespace coder-observability --create-namespace
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
      prometheus.io/scrape: 'true'
      prometheus.io/port: '2112'
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
kubectl -n <namespace> port-forward svc/grafana 3000:80
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
    name: grafana-admin             # this matches the "existingSecret" field above
  stringData:
    username: '<your username>'     # this matches the "userKey" field above
    password: '<your password>'     # this matches the "passwordKey" field above
  ```

## Usage

Please refer to the [`values.yaml`](coder-observability/values.yaml) file for all available configuration options.