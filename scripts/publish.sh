#!/usr/bin/env bash
set -euox pipefail

version=$("$(dirname "${BASH_SOURCE[0]}")/version.sh")
mkdir -p build/helm
helm package coder-observability --version=${version} --dependency-update --destination build/helm
gsutil cp gs://helm.coder.com/observability/index.yaml build/helm/index.yaml
helm repo index build/helm --url https://helm.coder.com/observability --merge build/helm/index.yaml
gsutil -h "Cache-Control:no-cache,max-age=0" cp build/helm/index.yaml gs://helm.coder.com/observability/
gsutil -h "Cache-Control:no-cache,max-age=0" cp build/helm/coder-observability-${version}.tgz gs://helm.coder.com/observability/
gsutil -h "Cache-Control:no-cache,max-age=0" cp artifacthub-repo.yaml gs://helm.coder.com/observability/

echo $version