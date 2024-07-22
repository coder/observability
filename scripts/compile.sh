#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm --repository-cache /tmp/cache repo update
# Check for unexpected changes.
# Helm dependencies are versioned using ^ which accepts minor & patch changes:
# 	e.g. ^1.2.3 is equivalent to >= 1.2.3 < 2.0.0
helm dependency update coder-observability/
# We *expect* that the versions will change in the rendered template output, so we ignore those, but
# if there are changes to the manifests themselves then we need to fail the build to force manual review.
helm template -f coder-observability/values.yaml coder-observability coder-observability/ | \
  yq 'del(.spec.template.spec.containers[].image, .metadata.labels."helm.sh/chart", .metadata.labels."app.kubernetes.io/version")' - \
  > compiled/resources.yaml

check_unstaged "compiled"