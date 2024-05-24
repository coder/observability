#!/usr/bin/env bash
set -euo pipefail

temp_dir="$(mktemp -d)"
rules_file="${temp_dir}/rules.yaml"
helm template coder-o11y coder-observability -f coder-observability/values.yaml --show-only templates/configmap-prometheus-alerts.yaml > ${rules_file}

for key in $(yq e '.data | keys' -o csv ${rules_file} | tr ',' "\n"); do
  file="${temp_dir}/${key}"
  echo "=========================== [${file}] ==========================="

  yq e ".data[\"${key}\"]" ${rules_file} > ${file}
  go run github.com/cloudflare/pint/cmd/pint@latest -l DEBUG lint ${file}
done