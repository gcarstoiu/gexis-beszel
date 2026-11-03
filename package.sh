#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Build dist/beszel-<version>.tar.gz and dist/beszel-hub-<version>.tar.gz, each
# with plugin.json at its top level: Beszel's own binary from its pinned
# release (checked by sha256), its licence, and this repository's run script.
# The same pins and files give the same bytes, so a listed archive's sha256 can
# be checked against the tag it was built from.
#
# Downloads are kept in $GEXIS_BUILD_CACHE (named by sha256) if it is set.
set -eu
cd "$(dirname "$0")"
. ./pins.sh
cache="${GEXIS_BUILD_CACHE:-$PWD/cache}"
mkdir -p dist "$cache"

fetch() {  # asset sha256 -> path of the checked tarball
	f="$cache/$2"
	if ! { [ -f "$f" ] && echo "$2  $f" | sha256sum -c - > /dev/null 2>&1; }; then
		curl -fsSL -o "$f.part" "$BASE/$1"
		echo "$2  $f.part" | sha256sum -c - > /dev/null || { rm -f "$f.part"; echo "ERROR: $1 is not the pinned file" >&2; exit 1; }
		mv "$f.part" "$f"
	fi
	echo "$f"
}

pack() {  # dir binary-in-tarball name-in-archive asset sha256
	dir=$1 bin=$2 name=$3
	tarball=$(fetch "$4" "$5")
	id=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["id"])' "$dir/plugin.json")
	version=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["version"])' "$dir/plugin.json")
	[ "$version" = "${BESZEL_VERSION#v}-$REVISION" ] \
		|| { echo "ERROR: $dir/plugin.json says $version, the pins ${BESZEL_VERSION#v}-$REVISION" >&2; exit 1; }
	work=$(mktemp -d "$PWD/dist/.work.XXXXXX")
	tar -xzf "$tarball" -C "$work" "$bin" LICENSE
	[ "$bin" = "$name" ] || mv "$work/$bin" "$work/$name"
	mv "$work/LICENSE" "$work/LICENSE.beszel"
	cp "$dir/plugin.json" "$dir/run" "$work/"
	chmod 755 "$work/$name" "$work/run"; chmod 644 "$work/plugin.json" "$work/LICENSE.beszel"
	out="dist/$id-$version.tar.gz"
	(cd "$work" && tar --sort=name --mtime=@0 --owner=0 --group=0 --numeric-owner \
		-cf - plugin.json run "$name" LICENSE.beszel) | gzip -n -9 > "$out"
	rm -rf "$work"
	echo "$out $(stat -c %s "$out") bytes, sha256 $(sha256sum "$out" | cut -d' ' -f1)"
}

pack agent beszel-agent beszel-agent "$AGENT_ASSET" "$AGENT_SHA256"
pack hub beszel beszel-hub "$HUB_ASSET" "$HUB_SHA256"
