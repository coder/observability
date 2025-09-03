#!/usr/bin/env bash

# This script generates the version string used by the helm chart, including for
# dev versions. Note: the version returned by this script will NOT include the "v"
# prefix that is included in the Git tag.
# The script can also bump the version based on the given argument (major, minor, patch).

set -euo pipefail

remote_url=$(git remote get-url origin)
# Newest tag by semantic version (may include prerelease like -rc/-beta/-alpha)
current_version="$(git tag -l | sort --version-sort | tail -n1)"
# Newest stable version tag (strict X.Y.Z; excludes prereleases)
stable_version="$(git tag -l | sort --version-sort | grep -E '^(v)?[0-9]+\.[0-9]+\.[0-9]+$' | tail -n1)"

function help() {
    echo "$0 [options] [arguments]"
    echo " "
    echo "options:"
    echo "-h, --help      show brief help"
    echo "-c, --current   show the current version"
    echo "-s, --stable    show the current stable version"
    echo "-b, --bump      bump the version based on the given argument"
    exit 0
}

function bump_version() {
  local version=$1
  local new_version

  if [[ $version == "major" ]]; then
    new_version=$(echo $stable_version | sed 's/^v//' | awk -F. '{print "v" $1+1".0.0"}')
  elif [[ $version == "minor" ]]; then
    new_version=$(echo $stable_version | awk -F. '{print $1"."$2+1".0"}')
  elif [[ $version == "patch" ]]; then
    new_version=$(echo $stable_version | awk -F. '{print $1"."$2"."$3+1}')
  else
    echo "Error: Unknown argument $version"
    exit 1
  fi

  echo $new_version
}

# Show the newest tag (stable or prerelease like -rc/-beta/-alpha), without the leading 'v'.
function show_current() {
    echo "${current_version#v}"
}

# Show the newest stable tag (strict X.Y.Z), without the leading 'v'.
function show_stable() {
    echo "${stable_version#v}"
}

if [ $# == 0 ]; then
  show_current
fi

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      help
      ;;
    -c|--current)
      show_current
      shift
      ;;
    -s|--stable)
      show_stable
      shift
      ;;
    -b|--bump)
      if [ $# -lt 2 ]; then
        echo "Error: Missing argument for bump"
        exit 1
      fi
      shift
      bump_version $1
      shift
      ;;
    *)
      echo "Error: Unknown argument $1"
      exit 1
      ;;
  esac
done
