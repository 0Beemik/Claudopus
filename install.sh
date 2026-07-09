#!/usr/bin/env bash
# Omnipus installer — copies the skill into a Claude Code skills directory.
# Usage:
#   ./install.sh            # install globally to ~/.claude/skills/omnipus
#   ./install.sh --project  # install into ./.claude/skills/omnipus (current repo)
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.claude/skills/omnipus"

if [[ "${1:-}" == "--project" ]]; then
  dest="$(pwd)/.claude/skills/omnipus"
else
  dest="$HOME/.claude/skills/omnipus"
fi

mkdir -p "$(dirname "$dest")"
cp -rT "$src" "$dest"
echo "Omnipus installed to: $dest"
echo "Run /reload-skills in Claude Code, then invoke with: /omnipus <goal>"
