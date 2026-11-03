# Beszel for Gexis Player

[Beszel](https://beszel.dev)'s agent and hub as two
[Gexis Player](https://github.com/gcarstoiu/gexis-player) plugins, installed
from the player's plugin catalogue (*Settings → Plugins → Add plugins*):

- **Beszel** (`beszel`) - the agent. Reports how the player is doing (CPU,
  memory, temperature, disk, network) to a Beszel hub, on this player or
  elsewhere. Settings: the hub's address, the token and the hub's public key,
  all from the hub's *Add System* dialog.
- **Beszel hub** (`beszel-hub`) - a hub on the player, with its own page on
  port 8095 keeping the history of every agent that reports to it.

Until Gexis Player 1.12.x both shipped with the player; since its ADR-0174
they come from the catalogue and update on their own. A player that had one
switched on carries it over, its identity and history kept.

## What each archive holds

`plugin.json` at the top, Beszel's own binary from its pinned release
(`pins.sh`, checked by sha256), Beszel's licence (`LICENSE.beszel`, MIT) and a
`run` script:

- the agent's keeps its identity in the plugin's folder and **listens on
  nothing**: it starts the agent with `--listen -1` and stops it for good if
  anything listens on the agent's SSH port two seconds later;
- the hub's serves on `0.0.0.0:8095`, its database in the plugin's folder.

Both run in the player's plugin sandbox: a temporary user, the system
read-only, `/proc` and `/sys` readable, the network open.

## Building

```sh
./package.sh          # dist/beszel-<version>.tar.gz, dist/beszel-hub-<version>.tar.gz
```

The same pins and files give the same bytes, so a listed archive can be
checked against the tag it was built from. A plugin's version is Beszel's
plus this repository's revision (`0.21.1-1`).

## Licence

The scripts here: GPL-3.0-or-later (`LICENSE`). Beszel: MIT, by henrygd
(`LICENSE.beszel` in each archive).
