# noop-modc

Container image of [Noop](https://github.com/huacnlee/noop) (MIT, by huacnlee) for Omarchy Server and the
[Modc App Store](https://github.com/MyOwnDataCenter/Modc-app-store).

It runs Noop as a standalone primary with no Cloudflare Worker (`HUB_SYNC=local`): all data lives in `/data`,
and the built-in web chat listens on port 8787. The web chat token is `NOOP_TOKEN`, and the public tunnel is off.
Claude Code, Codex and `gh` are included. Sign them in from Noop's Settings › Keys (for example a
`claude setup-token` token).

```
podman build -t ghcr.io/nickpstone/noop:1.0.9-2 .
```

Noop's own git self-update is off inside the image. To update, bump `NOOP_VERSION` and build a new tag.

## Signing in

Noop's web app normally signs in by email through the Worker, which this image doesn't run. The image adds
`/signin.html`, which asks for the app's password (`NOOP_TOKEN`) and saves it where the web app looks. Opening
`/?token=<password>` does the same in one step.

## Language

Noop writes its messages and agent replies in Simplified Chinese unless `[owner] language = "en"` is set in
`config.toml`. The web app's language menu only changes the app's own labels. On first start this image sets it
to `NOOP_LANGUAGE`, which defaults to `en`.
