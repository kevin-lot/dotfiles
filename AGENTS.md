# AGENTS.md

Personal config, symlinked into `~/.config` by `install.sh`.

- `config/<tool>/` — one dir per tool (zsh, niri, starship, lazygit, …)
- New tool: add `config/<tool>` and a matching `ln -sf` line in `install.sh`.
- Files are live via symlinks — edits apply immediately.
- `docs/` — how-to guides (e.g. macOS OrbStack → Colima).
