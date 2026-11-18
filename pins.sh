# Beszel's release, pinned: both halves come from one upstream version, each
# tarball by its sha256 (the player's packaging/beszel-*/pins.sh until
# ADR-0174 moved them here).
BESZEL_VERSION="v0.21.2"
AGENT_ASSET="beszel-agent_linux_arm64.tar.gz"
AGENT_SHA256="4f5dcea27c3f9e2ba30218e7d7039f4df548ded1c470df9eefe00975722aad13"
HUB_ASSET="beszel_linux_arm64.tar.gz"
HUB_SHA256="884f8b16b80032f2782ceead2cae8aaab020232d7277e724cd17bca2b8ef8327"
BASE="https://github.com/henrygd/beszel/releases/download/${BESZEL_VERSION}"
# This plugin's own revision, raised with every change to what it packs.
REVISION=1
