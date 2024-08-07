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