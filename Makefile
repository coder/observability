# Use a single bash shell for each job, and immediately exit on failure
SHELL := bash
.SHELLFLAGS = -ceu
.ONESHELL:

# This doesn't work on directories.
# See https://stackoverflow.com/questions/25752543/make-delete-on-error-for-directory-targets
.DELETE_ON_ERROR:

all: lint
.PHONY: all

lint: lint/helm
.PHONY: lint

lint/helm: lint/helm/coder-observability
.PHONY: lint/helm

lint/helm/coder-observability:
	helm dependency update --skip-refresh coder-observability/
	helm lint --strict --set coder.image.tag=v0.0.1 coder-observability/
.PHONY: lint/helm/coder-observability

build: # TODO
	echo helm package --version "${VERSION}"