# Publishing the Coder Observability Chart

This repo supports both official (stable) releases and release candidates (RCs).

Releases are made by the `publish-helm` workflow (`.github/workflows/release.yaml`). Anyone with
write access can start one; a member of `release-managers` other than the person who started it
must approve it. Only then is the tag created (by the `coder-release-publisher` App; nobody can
push release tags by hand) and the chart published to helm.coder.com.

## Official release (stable)

Use this when you’re ready to publish a new release.

1) Make desired changes, merge them to `main` and ensure CI is green
2) Start the release of the head of `main`:
    - Patch: `make publish-patch`
    - Minor: `make publish-minor`
    - Major: `make publish-major`

   This dispatches `publish-helm` on `main` with the next version (e.g. `v0.4.1`) and the commit.
3) Ask a release manager to approve the `release-approval` deployment in the workflow run.

## Release candidate (RC)

Start the workflow by hand with an RC version and the commit on `main` to release:

```shell
gh workflow run release.yaml --repo coder/observability --ref main \
  -f version=v0.4.0-rc1 -f commit="$(git rev-parse origin/main)"
```

Then ask a release manager to approve it, as above.

## Helm repo

Use Artifact Hub to browse/search releases: https://artifacthub.io/packages/helm/coder-observability/coder-observability
