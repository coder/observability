# Use a single bash shell for each job, and immediately exit on failure
SHELL := bash
.SHELLFLAGS = -ceu
.ONESHELL:

# This doesn't work on directories.
# See https://stackoverflow.com/questions/25752543/make-delete-on-error-for-directory-targets
.DELETE_ON_ERROR:

all: lint
.PHONY: all

lint: build lint/helm lint/rules readme
	@if ! git diff --quiet; then \
		echo "Error: uncommitted changes."; \
		exit 1; \
	fi;
.PHONY: lint

lint/helm: lint/helm/coder-observability
.PHONY: lint/helm

lint/helm/coder-observability:
	helm lint --strict --set coder.image.tag=v$(shell ./scripts/version.sh) coder-observability/
.PHONY: lint/helm/coder-observability

build:
	helm --repository-cache /tmp/cache repo update
	helm dependency update coder-observability/
	helm template coder-observability coder-observability/ > compiled/resources.yaml
	# Check for unexpected changes.
	# Helm dependencies are versioned using ^ which accepts minor & patch changes:
	# 	e.g. ^1.2.3 is equivalent to >= 1.2.3 < 2.0.0
	# We *expect* that the versions will change in the rendered template output, so we ignore those, but
	# if there are changes to the manifests themselves then we need to fail the build to force manual review.
	@if git diff -- compiled/resources.yaml | grep -ve 'helm.sh/chart' -e 'app.kubernetes.io/version' -e 'image:' | egrep '^(\+|\-)[^\+|\-]'; then \
		echo "Error: uncommitted changes in 'compiled/resources.yaml'."; \
		exit 1; \
	fi;
.PHONY: build

lint/rules: lint/helm/prometheus-rules
.PHONY: lint/rules

lint/helm/prometheus-rules:
	@./scripts/lint-rules.sh

.PHONY: lint/helm/prometheus-rules

# Usage: publish-patch, publish-minor, publish-major
# Publishing is handled by GitHub Actions, triggered by tag creation.
publish-%:
	version=$(shell ./scripts/version.sh --bump $*) && \
	git tag --sign "$$version"  -m "Release: $$version" && \
	git push origin tag "$$version"

readme:
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
	helm-docs --output-file ../README.md \
		--values-file=values.yaml --chart-search-root=coder-observability --template-files=../README.gotmpl