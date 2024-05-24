# Coder Observability Chart

**<span style="color:orange;">**NOTE:** this Helm chart is in BETA; use with caution.</span>**

## Overview

This chart contains a highly opinionated set of integrations between Grafana, Loki, Prometheus, Alertmanager, and Grafana Agent.

Dashboards, alerts, and runbooks are preconfigured for monitoring [Coder](https://coder.com/) installations.

Out of the box:

Metrics will be scraped from all pods which have a `prometheus.io/scrape=true` annotation.<br>
Logs will be scraped from all pods in the Kubernetes cluster.

## Requirements

### General

- Helm 3.7+

### Coder

- If your Coder installation is deployed in Kubernetes:
  - If your installation is not in a namespace named `coder`, you will need to modify:

    ```yaml
    global:
      coder:
        controlPlaneNamespace: <your namespace>
        externalProvisionersNamespace: <your namespace>
    ```
- For all other deployment modes:
  - Ensure your Coder installation is accessible to the resources created by this chart
  - Set `global.coder.scrapeMetrics` such that the metrics can be scraped from your installation
  - If you would like your logs scraped from a process outside Kubernetes, you need to mount the log file(s) in and configure Grafana Agent to scrape them; here's an example configuration:

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
- Ensure these environment variables are set:
  - `CODER_PROMETHEUS_ENABLE=true`
  - `CODER_PROMETHEUS_COLLECT_AGENT_STATS=true`

- Ensure these labels exist on your coder & provisioner deployments:
  - `prometheus.io/scrape=true`
  - `prometheus.io/port=2112` (ensure this matches the port defined by `CODER_PROMETHEUS_ADDRESS`)

  If you use the [`coder/coder` helm chart](https://github.com/coder/coder/tree/main/helm), you can use the following:
  ```yaml
  coder:
    podAnnotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port: '2112'
  ```

  For more details, see the [coder documentation on exposing Prometheus metrics](https://coder.com/docs/v2/latest/admin/prometheus).

### Postgres

- Ensure the namespace into which you will be installing this chart has access your Postgres instance
- Create a secret with your Postgres password and reference it as follows:

  ```yaml
  global:
    postgres:
      mountSecret: <your secret name here>
  ```
  
  The secret should be in the form of `PGPASSWORD=<your password>`, as this secret will be used to create an environment variable.

## Usage

Please refer to the [`values.yaml`](coder-observability/values.yaml) file for all available configuration options.