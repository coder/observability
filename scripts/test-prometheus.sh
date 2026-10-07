#!/usr/bin/env bash
set -euo pipefail

temp_dir="$(mktemp -d)"
container=""
cleanup() {
  if [[ -n "$container" ]]; then
    docker logs "$container"
    docker rm -f "$container" >/dev/null
  fi
  rm -rf "$temp_dir"
}
trap cleanup EXIT

# Compile fresh manifests so the config, image, and arguments all come from the
# same chart. Accept a packaged chart too, for the pre-publish check.
helm template coder-observability "${1:-coder-observability}" \
  --namespace coder-observability > "$temp_dir/resources.yaml"
yq -e 'select(.kind == "StatefulSet" and .metadata.name == "prometheus") |
  .spec.template.spec.containers[] | select(.name == "prometheus-server")' \
  "$temp_dir/resources.yaml" > "$temp_dir/server.yaml"
image="$(yq -er '.image' "$temp_dir/server.yaml")"
mapfile -t args < <(yq -r '.args[]' "$temp_dir/server.yaml")

mkdir -p "$temp_dir/config/alerts" "$temp_dir/serviceaccount"
# Extract the embedded config as text, without parsing/re-serializing its YAML.
yq -er 'select(.kind == "ConfigMap" and .metadata.name == "prometheus") |
  .data."prometheus.yml"' "$temp_dir/resources.yaml" > "$temp_dir/config/prometheus.yml"
yq -e 'select(.kind == "ConfigMap" and .metadata.name == "coder-metrics-alerts") |
  .data' "$temp_dir/resources.yaml" > "$temp_dir/alerts.yaml"
for key in $(yq -r 'keys | .[]' "$temp_dir/alerts.yaml"); do
  KEY="$key" yq -r '.[strenv(KEY)]' "$temp_dir/alerts.yaml" > "$temp_dir/config/alerts/$key"
done

# The default config uses in-cluster Alertmanager discovery. Supply local
# service-account files and point discovery at loopback, not a real cluster.
printf 'smoke-test-only\n' > "$temp_dir/serviceaccount/token"
cp /etc/ssl/certs/ca-certificates.crt "$temp_dir/serviceaccount/ca.crt"
container="$(docker run -d \
  -v "$temp_dir/config:/etc/config:ro" \
  -v "$temp_dir/serviceaccount:/var/run/secrets/kubernetes.io/serviceaccount:ro" \
  --tmpfs /data:rw,mode=1777 \
  -p 127.0.0.1::9090 \
  -e KUBERNETES_SERVICE_HOST=127.0.0.1 -e KUBERNETES_SERVICE_PORT=9 \
  "$image" "${args[@]}")"

# Readiness succeeds only after Prometheus has loaded its config and rules.
address="$(docker port "$container" 9090/tcp)"
curl --fail --silent --show-error --retry 30 --retry-all-errors \
  --retry-delay 1 --retry-max-time 60 --max-time 2 "http://$address/-/ready"
