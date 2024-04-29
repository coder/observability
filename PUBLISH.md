# Publishing the Coder Observability Chart

- make desired changed
- create & push a new tag
- run `scripts/version.sh` which pulls the latest version and validate it is correct
- run `scripts/publish.sh` which uses the above version, packages & uploads the chart, and updates registries