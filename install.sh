#!/usr/bin/env bash
# Omnipus installer — installs the full engineering system (skill + fleet +
# commands + hooks), and runs a date-based doc self-sync check.
#
# Usage:
#   ./install.sh --project   # install into ./.claude of the CURRENT repo (recommended)
#   ./install.sh             # install global pieces into ~/.claude (agents/commands/skills)
#
# Why --project is recommended: Omnipus is a *system*, not a lone skill. The
# skill delegates to the agent fleet and relies on settings.json (models, hooks,
# permissions). Project scope keeps them together. Global scope installs the
# additive pieces (agents, commands, skills) but will NOT clobber your global
# settings.json or CLAUDE.md — it prints how to merge those yourself.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_src="$root/.claude/skills/omnipus"

# ---------------------------------------------------------------------------
# Self-sync: if the doc snapshots are older than the interval, fetch fresh ones
# and drop a SYNC_PENDING marker for the orchestrator to reconcile on next run.
# Bash only detects + fetches; the model does the actual map update. Degrades
# gracefully — the only failure mode is the docs ceasing to exist.
# ---------------------------------------------------------------------------
sync_docs() {
  local vf="$skill_src/version.json"
  [[ -f "$vf" ]] || { echo "  (no version.json — skipping doc sync)"; return 0; }

  local last interval
  last="$(grep -o '"docs_last_synced"[[:space:]]*:[[:space:]]*"[^"]*"' "$vf" | sed 's/.*"\([0-9-]*\)".*/\1/')"
  interval="$(grep -o '"sync_interval_days"[[:space:]]*:[[:space:]]*[0-9]*' "$vf" | grep -o '[0-9]*$')"
  [[ -n "$last" && -n "$interval" ]] || { echo "  (version.json unreadable — skipping doc sync)"; return 0; }

  local now_epoch last_epoch age
  now_epoch="$(date -u +%s)"
  if date -d "$last" +%s >/dev/null 2>&1; then
    last_epoch="$(date -d "$last" +%s)"                       # GNU date
  elif date -j -f "%Y-%m-%d" "$last" +%s >/dev/null 2>&1; then
    last_epoch="$(date -j -f "%Y-%m-%d" "$last" +%s)"          # BSD date
  else
    echo "  (could not parse date '$last' — skipping doc sync)"; return 0
  fi
  age=$(( (now_epoch - last_epoch) / 86400 ))

  echo "  Docs last synced $last ($age days ago); interval ${interval}d."
  if (( age < interval )); then
    echo "  Snapshots current — no sync needed."
    return 0
  fi

  echo "  Snapshots stale — fetching fresh docs..."
  local incoming="$skill_src/references/_incoming"
  mkdir -p "$incoming"
  local cmd_url tool_url ok=true
  cmd_url="$(grep -o '"commands"[[:space:]]*:[[:space:]]*"[^"]*"' "$vf" | sed 's/.*"\(https[^"]*\)".*/\1/')"
  tool_url="$(grep -o '"tools"[[:space:]]*:[[:space:]]*"[^"]*"' "$vf" | sed 's/.*"\(https[^"]*\)".*/\1/')"

  fetch() { # url dest
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$1" -o "$2" 2>/dev/null
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$2" "$1" 2>/dev/null
    else
      return 2
    fi
  }

  fetch "$cmd_url" "$incoming/commands.remote.md" || ok=false
  fetch "$tool_url" "$incoming/tools.remote.md"   || ok=false

  if [[ "$ok" == true ]]; then
    date -u +%Y-%m-%d > "$skill_src/references/SYNC_PENDING"
    echo "  ✓ Fresh docs staged. Omnipus will reconcile the maps on next /omnipus run."
  else
    echo "  ⚠ Could not fetch docs (offline or docs unavailable). Keeping last good snapshot."
    rmdir "$incoming" 2>/dev/null || true
  fi
}

echo "== Omnipus install =="
echo "Checking doc freshness..."
sync_docs

if [[ "${1:-}" == "--project" ]]; then
  # Full system into the current repo's .claude (merge, don't wipe).
  dest="$(pwd)/.claude"
  echo "Installing full system into: $dest"
  mkdir -p "$dest"
  cp -r "$root/.claude/." "$dest/"
  echo "✓ Installed: skill + agents + commands + skills + hooks + settings + memory"
  echo "Run /reload-skills in Claude Code, then: /omnipus <goal>"
else
  # Global: install additive pieces only; never clobber user global config.
  echo "Installing global additive pieces into: $HOME/.claude"
  for part in agents commands skills; do
    mkdir -p "$HOME/.claude/$part"
    cp -r "$root/.claude/$part/." "$HOME/.claude/$part/"
    echo "  ✓ $part"
  done
  echo ""
  echo "NOTE: global settings.json and CLAUDE.md were NOT overwritten (they're yours)."
  echo "To get the Fable/Opus model tiering + run-ledger hooks, either:"
  echo "  • install per-project:  ./install.sh --project   (recommended), or"
  echo "  • merge these into your ~/.claude/settings.json manually:"
  echo "      - \"model\": \"claude-fable-5\""
  echo "      - the hooks block from $root/.claude/settings.json"
  echo "Run /reload-skills in Claude Code, then: /omnipus <goal>"
fi
