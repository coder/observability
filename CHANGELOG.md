# CHANGELOG

## Unreleased

- BREAKING: replaces the `grafana-agent` subchart with Grafana Alloy (`alloy` chart 1.13.1). Rename any `grafana-agent:` values overrides to `alloy:`.
- Pod `job` label changes from `<ns>/grafana-agent/grafana-agent` to `<ns>/alloy/alloy`; update queries and alerts that match the old label.
- Alloy listens on port 12345 instead of 80.
- Series now carry the labels common Kubernetes dashboards select on. cAdvisor series get a `node` label, kube-state-metrics' own `node` label is no longer overwritten by the node its pod runs on, and `node_*` series keep their `instance` label (it is still dropped on everything else).
- New `global.telemetry.metrics.externalLabels` adds labels (for example `cluster`) to every series the collector writes. Empty by default.
- New `alloy.kubeletVolumeStats` scrapes `kubelet_volume_stats_*` (PVC capacity and usage) from each kubelet, enabled by default. Set `alloy.kubeletVolumeStats.enabled: false` to turn it off.
- New `alloy.kubeletTLS` configures TLS for the cAdvisor and kubelet scrapes. The defaults (`insecure_skip_verify: true`) match the previous behaviour; set `insecure_skip_verify: false` and `ca_file` to verify the kubelet certificate.
- Alloy `ClusterRole` is narrowed to `pods`, `nodes` and `nodes/metrics`. It no longer grants read access to `secrets` and `configmaps`. If you add components through `alloy.extraBlocks` that need more access, override `alloy.rbac.rules` and `alloy.rbac.clusterRules`.
- `node_uname_info` carries the Kubernetes node name in its `nodename` label instead of the OS hostname, so dashboards that match it against `kube_node_info`'s `node` work when nodes are named by instance ID.

## v0.3.0

- Adding prebuilt workspace dashboard & alerts

## v0.2.1

- Upgraded subcharts
  - Loki: upgraded to v6.7.1 -> v6.7.3
- FIX: `listen-address` duplicate removed in `prometheus-config-reloader`

## v0.2.0

- Upgraded subcharts
  - Grafana: upgraded from v7.3.7 -> v7.3.12
  - Prometheus: upgraded to v25.18.0 -> v25.24.1
  - Loki: upgraded to v6.3.4 -> v6.7.1

## v0.1.0

- Lint Helm chart in CI

## v0.0.2 -> v0.0.11

- Several stability & configurability improvements

## v0.0.1

- Initial release
- New `global.telemetry.metrics.remoteWriteURL` points the collector at a Prometheus outside this release. It can then be combined with `prometheus.enabled: false`, which previously failed to render. Empty by default, which keeps writing to the bundled Prometheus.
