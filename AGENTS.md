# kora_interior agent guide

`kora_interior` is a client-only Kora FiveM resource that provides interior shell models and exports to spawn them: legacy shell factories (also exported as `qb-interior`) in `client/main.lua` (16 bundled models) and `client/optional.lua` (109 factories for optional packs), plus `createGeometry`/`removeGeometry` for teleport-free local geometry. Layout: `fxmanifest.lua`, `config.lua`, `client/`, `stream/` (bundled models and `.ytyp`), `tests/` (offline Lua/Python checks and a kora_qa feature file), `docs/`.

## Documentation

User-facing documentation lives in `docs/` (Markdown, published via the Kora Docusaurus site, kora_docs_next). Read `docs/index.md` first (overview and documentation map). Layout: `index.md` (hub), `installation.md`, `how-to-use.md`, `api/` (`index.md`, `geometry.md` for `createGeometry`/`removeGeometry`, `shells.md` for `createShell`, named factories and `DespawnInterior`, `configuration.md` for `Config`), and topic pages `shell-catalog.md`, `events.md`, `shell-geometry.md`, `testing.md`, `troubleshooting.md`. There is no `commands.md` because the resource has no commands. Exports change -> update `api/`; config change -> `api/configuration.md`; factory added or changed -> `shell-catalog.md` and `api/shells.md`.

When you add, change, or remove a feature, config option, command, export, event, item, permission, or database table/column, update the matching page in `docs/` in the same change. Keep docs accurate to the code; do not document behaviour that does not exist.

Docs rules: plain Markdown with `title`/`sidebar_position` front matter (no `id`/`slug`), relative links only between docs pages, assets inside `docs/`, fenced code blocks with a language, and no raw `<`, `>`, `{`, `}` outside code (pages are parsed as MDX). The release version comes from `fxmanifest.lua`'s `version` field.
