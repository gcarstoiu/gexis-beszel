# Beszel's release, pinned: both halves come from one upstream version, each
# tarball by its sha256 (the player's packaging/beszel-*/pins.sh until
# ADR-0174 moved them here).
BESZEL_VERSION="v0.21.1"
AGENT_ASSET="beszel-agent_linux_arm64.tar.gz"
AGENT_SHA256="a6ea544976b9a74398ac88d5da5bb96813d9a2e353a37bbfdb6a903fa8ba1838"
HUB_ASSET="beszel_linux_arm64.tar.gz"
HUB_SHA256="c2357b94d36febfd0c6df9f89f523fff6f6df69a4b8ac91a8b262d2b7fdb0584"
BASE="https://github.com/henrygd/beszel/releases/download/${BESZEL_VERSION}"
# This plugin's own revision, raised with every change to what it packs.
REVISION=1
