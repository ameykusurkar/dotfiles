# Claude Code Plugin

Shared Claude Code skills, distributed as a local marketplace plugin.

## Setup

1. Add the marketplace via `/plugin` → Marketplaces → Add directory:
   ```
   $DOTFILES/claude
   ```
2. Install the `me` plugin from the marketplace.

Shared skills are available as `/me:skill-name`. Local per-machine skills go in `~/.claude/skills/`.

## Migration

If you previously installed skills via `make claude`, clean up old symlinks:

```
make clean-claude-deprecated
```
