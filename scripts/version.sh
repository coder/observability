#!/usr/bin/env bash

# This script generates the version string used by the helm chart, including for
# dev versions. Note: the version returned by this script will NOT include the "v"
# prefix that is included in the Git tag.

set -euo pipefail

if [[ -n "${FORCE_VERSION:-}" ]]; then
	echo "${FORCE_VERSION}"
	exit 0
fi

remote_url=$(git remote get-url origin)
last_tag="$(git tag -l | sort -h | tail -n1)"

# Remove the "v" prefix.
echo "${last_tag#v}"
