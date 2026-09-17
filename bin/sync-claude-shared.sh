#!/usr/bin/env bash
# sync-claude-shared.sh — copy the team-shared Claude Code config from a
# claude-shared checkout into this repo's .claude/ directory.
#
# claude-shared (https://github.com/stefanwb/claude-shared) is the source of
# truth for agents, shared skills, and hooks. dotfiles carries installed copies
# so ~/.claude can point at one directory. Run this after pulling claude-shared,
# then review `git diff` and commit.
#
# Usage: bin/sync-claude-shared.sh [path-to-claude-shared]
#        CLAUDE_SHARED=~/src/claude-shared bin/sync-claude-shared.sh
set -euo pipefail

src="${1:-${CLAUDE_SHARED:-$HOME/git-work/claude-shared}}"
dest="$(cd "$(dirname "$0")/.." && pwd)/.claude"

if [ ! -d "$src/agents" ] || [ ! -d "$src/skills" ]; then
  echo "error: '$src' does not look like a claude-shared checkout (no agents/ and skills/)" >&2
  echo "       pass the path as the first argument or set CLAUDE_SHARED" >&2
  exit 1
fi

mkdir -p "$dest/agents" "$dest/skills" "$dest/hooks"

cp "$src"/agents/*.md "$dest/agents/"

for skill in "$src"/skills/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  name="$(basename "$skill")"
  rm -rf "$dest/skills/$name"
  cp -R "$skill" "$dest/skills/$name"
done

if [ -d "$src/hooks" ]; then
  for hook in "$src"/hooks/*.sh; do
    [ -f "$hook" ] || continue
    cp "$hook" "$dest/hooks/"
    chmod +x "$dest/hooks/$(basename "$hook")"
  done
fi

echo "synced from $src into $dest"
git -C "$(dirname "$dest")" status --short -- .claude
