#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/siderolabs/omni"
TOOL_NAME="omnictl"
TOOL_TEST="omnictl --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if omnictl is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

get_machine_os() {
  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  case "${OS}" in
  darwin*) echo "darwin" ;;
  linux*) echo "linux" ;;
  freebsd*) echo "freebsd" ;;
  *) fail "OS not supported: ${OS}" ;;
  esac
}

get_machine_arch() {
  local ARCH
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

  case "${ARCH}" in
  x86_64) echo "amd64" ;;
  aarch64) echo "arm64" ;;
  armv8l) echo "arm64" ;;
  armv7l) arch="arm" ;;
  arm64) echo "arm64" ;;
  *) fail "Architecture not supported: $ARCH" ;;
  esac
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    grep -o '^v.*' |
    sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"
  if ! os=$(get_machine_os); then
    fail "$os"
  fi
  if ! arch=$(get_machine_arch); then
    fail "$arch"
  fi
  local platform="${os}-${arch}"

  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-${platform}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
