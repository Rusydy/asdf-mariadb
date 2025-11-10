#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/MariaDB/server"
TOOL_NAME="mariadb"
TOOL_TEST="mysql --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	# Dependency Checks
	for tool in curl jq; do
		command -v "$tool" >/dev/null 2>&1 || {
			echo "Error: '$tool' is required but not installed. Exiting." >&2
			exit 1
		}
	done

	# Use GitHub releases API which has the actual MariaDB release tags
	curl -s "https://api.github.com/repos/MariaDB/server/releases" |
		jq -r '.[].tag_name' |
		sed 's/^mariadb-//' |
		sort -Vr
}

list_all_versions() {
	list_github_tags
}

get_download_url() {
	local version="$1"
	local arch="linux-systemd-x86_64"

	# Parse dlm.mariadb.com to get actual download URL
	local browse_url="https://dlm.mariadb.com/browse/mariadb_server/${version}/bintar-${arch}/"
	local download_url

	echo "* Fetching download URL from MariaDB download service..." >&2
	download_url=$(curl -s "$browse_url" | grep -o "href=\"[^\"]*mariadb-${version}-${arch}\.tar\.gz[^\"]*\"" | head -1 | sed 's/href="//;s/"//')

	if [ -z "$download_url" ]; then
		fail "Could not find download URL for version $version"
	fi

	echo "$download_url"
}

download_release() {
	local version="$1"
	local filename="$2"
	local url

	url=$(get_download_url "$version")

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -L -o "$filename" "$url" || fail "Could not download $url"

	# Check if we got HTML instead of a tar.gz file
	if file "$filename" | grep -q "HTML"; then
		fail "Downloaded file is HTML, not a tar.gz archive. Check if version $version exists."
	fi
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		# Extract the downloaded archive
		echo "* Extracting $TOOL_NAME $version..."
		local archive_file="$ASDF_DOWNLOAD_PATH/${TOOL_NAME}-${version}.tar.gz"

		tar -xzf "$archive_file" -C "$ASDF_DOWNLOAD_PATH" || fail "Could not extract archive"

		# Move contents to install path
		mkdir -p "$install_path"

		# Find the extracted directory (could be mariadb-version-linux-systemd-x86_64)
		local extracted_dir
		extracted_dir=$(find "$ASDF_DOWNLOAD_PATH" -maxdepth 1 -type d -name "mariadb-${version}*" | head -1)

		if [ -n "$extracted_dir" ] && [ -d "$extracted_dir" ]; then
			cp -r "$extracted_dir"/* "$install_path/"
		else
			# Fallback: copy all files except the archive
			find "$ASDF_DOWNLOAD_PATH" -type f ! -name "*.tar.gz" -exec cp {} "$install_path/" \;
		fi

		# Create necessary directories
		mkdir -p "$install_path/.archives"

		# Test that the main executable exists
		test -x "$install_path/bin/mysql" || fail "Expected $install_path/bin/mysql to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

get_latest_stable_version() {
	list_all_versions | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -1
}
