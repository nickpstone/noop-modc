#!/bin/sh
# First start: seed Noop's data as a local-only primary. Every start: the web chat token is NOOP_TOKEN
# (the app's password on Omarchy Server), and the public Cloudflare tunnel stays off.
set -eu
: "${NOOP_TOKEN:?NOOP_TOKEN must be set}"
mkdir -p "$HOME" "$NOOP_HOME/data"

cat > "$NOOP_HOME/data/config.local.toml" <<TOML
# Written by the container on every start; put your own settings in the app's Settings page instead.
[host]
name = "noop"

[server]
enabled = true
host = "0.0.0.0"
port = 8787
token = "$NOOP_TOKEN"

[tunnel]
mode = "off"
TOML

if [ ! -f "$NOOP_HOME/data/config.toml" ]; then
  echo "noop: first start, setting up a local primary in $NOOP_HOME"
  bun /app/src/cli.ts init --primary </dev/null
  # Noop writes in Simplified Chinese unless [owner] language is "en"; the web app's language menu doesn't change it.
  # Default to NOOP_LANGUAGE (en); change it later in config.toml.
  sed -i "/^\[owner\]/a language = \"${NOOP_LANGUAGE:-en}\"" "$NOOP_HOME/data/config.toml"
fi

exec bun /app/src/cli.ts daemon
