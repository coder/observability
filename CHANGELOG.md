# CHANGELOG

## Unreleased

- BREAKING: replaces the `grafana-agent` subchart with Grafana Alloy (`alloy` chart 1.13.1). Rename any `grafana-agent:` values overrides to `alloy:`.
- Pod `job` label changes from `<ns>/grafana-agent/grafana-agent` to `<ns>/alloy/alloy`; update queries and alerts that match the old label.
- Alloy listens on port 12345 instead of 80.

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
