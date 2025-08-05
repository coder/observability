#!/usr/bin/env bash
set -euo pipefail

# check versions
HELM_VERSION=3.17
YQ_VERSION=4.45
[[ "$(helm version)" == *v${HELM_VERSION}* ]] || { echo "Expected helm version v${HELM_VERSION} but got $(helm version)" >&2; exit 1; }
[[ "$(yq --version)" == *v${YQ_VERSION}* ]] || { echo "Expected yq version v${YQ_VERSION} but got $(yq --version)" >&2; exit 1; }

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
helm template --namespace coder-observability -f coder-observability/values.yaml coder-observability coder-observability/ | \
  yq e 'del(.spec.template.spec.containers[].image, .metadata.labels."helm.sh/chart", .metadata.labels."app.kubernetes.io/version")' - \
  > compiled/resources.yaml

check_unstaged "compiled"