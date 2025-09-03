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
	./scripts/check-unstaged.sh
.PHONY: lint

lint/helm: lint/helm/coder-observability
.PHONY: lint/helm

lint/helm/coder-observability:
	helm lint --strict --set coder.image.tag=v$(shell ./scripts/version.sh) coder-observability/
.PHONY: lint/helm/coder-observability

build:
	./scripts/compile.sh
.PHONY: build

lint/rules: lint/helm/prometheus-rules
.PHONY: lint/rules

lint/helm/prometheus-rules:
	@./scripts/lint-rules.sh

.PHONY: lint/helm/prometheus-rules

# Set coder-observability/Chart.yaml version to the latest stable git tag
# TODO: auto-update chart version in Chart.yaml when a new release is published
chart/version-sync:
	version=$(shell ./scripts/version.sh -s) && \
	if [ -z "$$version" ]; then \
		echo "No git tag found. Cannot set Chart.yaml version" >&2; \
		exit 1; \
	fi; \
	yq -i e ".version = \"$$version\"" coder-observability/Chart.yaml
.PHONY: chart/version-sync

# Usage: publish-patch, publish-minor, publish-major
# Publishing is handled by GitHub Actions, triggered by tag creation.
publish-%:
	version=$(shell ./scripts/version.sh --bump $*) && \
	git tag --sign "$$version" -m "Release: $$version" && \
	git push origin tag "$$version"

# TODO: auto-update chart version in README files when a new release is published
readme: chart/version-sync
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
	helm-docs --output-file ../README.md \
		--values-file=values.yaml --chart-search-root=coder-observability --template-files=../README.gotmpl