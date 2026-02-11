# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Examples of OpenVidu v2 applications running on OpenVidu v3 through the v2 compatibility layer. Each example lives under `examples/` as a standalone Node.js app with its own `package.json`.

## Running an Example

Each example is independent. From within an example directory (e.g. `examples/virtual-background/`):

```bash
npm install
node index.js
```

The server starts on port 5000 (configurable via `SERVER_PORT` in `.env`). By default, examples connect to the public demo deployment at `meet-demo.openvidu.io`; configure `OPENVIDU_URL` and `OPENVIDU_SECRET` in `.env` for a custom deployment.

There are no tests, linting, or build steps — examples are plain JavaScript served directly.

## Architecture

Each example follows the same pattern:

- **Backend** (`index.js`): Express server exposing two REST endpoints (`POST /api/sessions` and `POST /api/sessions/:sessionId/connections`) using `openvidu-node-client-v2compatibility` to manage sessions/tokens. Serves frontend files from `public/`.
- **Frontend** (`public/`): Vanilla JS + jQuery. Uses `openvidu-browser-v2compatibility` loaded from GitHub releases CDN. Handles WebRTC session lifecycle (join, subscribe to streams, leave) and example-specific features.

## Version Management

`scripts/update-openvidu-version.sh <version>` updates all examples to a new v2compatibility version:
- Updates `openvidu-node-client-v2compatibility` in each `package.json`
- Updates `openvidu-browser-v2compatibility` CDN URLs in HTML files
- Runs `npm install` to regenerate lock files

The GitHub Actions release workflow (`.github/workflows/release.yml`) automates this: manually dispatch with a version, and it updates files, commits, tags, and creates a GitHub release.

## Adding a New Example

Create a new directory under `examples/` following the existing structure (`index.js` + `public/` with `index.html` and `app.js`). The version update script automatically discovers all directories under `examples/`.
