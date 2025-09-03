# Publishing the Coder Observability Chart

This repo supports both official (stable) releases and release candidates (RCs).

## Official release (stable)

Use this when you’re ready to publish a new release.

1) Make desired changes and ensure CI is green
2) Cut and push a new tag:
    - Patch: `make publish-patch`
    - Minor: `make publish-minor`
    - Major: `make publish-major`

This creates and pushes a new stable tag (e.g., 0.4.1), which kicks off a GitHub Action to package and publish the chart.

## Release candidate (RC)

To create a new RC version:

```shell
VERSION=v0.4.0-rc.1
git tag "$VERSION" -m "Release: $VERSION"
git push origin tag "$VERSION"
```

## Helm repo

Use Artifact Hub to browse/search releases: https://artifacthub.io/packages/helm/coder-observability/coder-observability