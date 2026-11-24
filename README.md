# noop-modc

Container image of [Noop](https://github.com/huacnlee/noop) (MIT, by huacnlee) for Omarchy Server and the
[Modc App Store](https://github.com/MyOwnDataCenter/Modc-app-store).

It runs Noop as a standalone primary with no Cloudflare Worker (`HUB_SYNC=local`): all data lives in `/data`,
and the built-in web chat listens on port 8787. The web chat token is `NOOP_TOKEN`, and the public tunnel is off.
Claude Code, Codex and `gh` are included. Sign them in from Noop's Settings › Keys (for example a
`claude setup-token` token).

```
podman build -t ghcr.io/nickpstone/noop:1.0.9 .
```

Noop's own git self-update is off inside the image. To update, bump `NOOP_VERSION` and build a new tag.
