# Noop (https://github.com/huacnlee/noop) packaged for Omarchy Server / Modc App Store.
# Runs Noop as a standalone primary with no Cloudflare: data stays in /data, web chat on :8787.
FROM docker.io/node:22-trixie-slim
COPY --from=docker.io/oven/bun:1.4.5 /usr/local/bin/bun /usr/local/bin/bun

ARG NOOP_VERSION=v1.0.9
LABEL org.opencontainers.image.source=https://github.com/nickpstone/noop-modc \
      org.opencontainers.image.description="Noop (huacnlee/noop) for Omarchy Server" \
      org.opencontainers.image.licenses=MIT

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git gh ca-certificates curl tini procps ripgrep openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g @anthropic-ai/claude-code @openai/codex \
 && npm cache clean --force

# The code comes from a release tag without .git, so Noop's git self-update stays off: update by bumping the image.
RUN git clone -q --depth 1 --branch "$NOOP_VERSION" https://github.com/huacnlee/noop /app \
 && rm -rf /app/.git \
 && cd /app && bun install --frozen-lockfile \
 && bun -e 'import { ensureWebClient } from "/app/src/webclient.ts"; process.exit((await ensureWebClient()) ? 0 : 1)' \
 && chmod -R a+rwX /app/app/dist

COPY entrypoint.sh /usr/local/bin/noop-entrypoint
RUN chmod 755 /usr/local/bin/noop-entrypoint

ENV HOME=/data/home NOOP_HOME=/data/noop HUB_SYNC=local PATH=/app/bin:$PATH
WORKDIR /app
EXPOSE 8787
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/noop-entrypoint"]
