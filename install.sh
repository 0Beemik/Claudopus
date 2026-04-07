#!/usr/bin/env bash
# Claudopus installer
# Usage:
#   ./install.sh              — installs into current project (./.claude/)
#   ./install.sh --global     — installs into user scope (~/.claude/)
#   ./install.sh --check      — validates an existing install

set -e

CLAUDOPUS_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log()    { echo -e "${BLUE}[claudopus]${NC} $1"; }
ok()     { echo -e "${GREEN}[ok]${NC} $1"; }
warn()   { echo -e "${YELLOW}[warn]${NC} $1"; }
error()  { echo -e "${RED}[error]${NC} $1"; exit 1; }

print_header() {
  echo ""
  echo -e "${BLUE}  ╔═══════════════════════════════╗${NC}"
  echo -e "${BLUE}  ║        Claudopus v${CLAUDOPUS_VERSION}        ║${NC}"
  echo -e "${BLUE}  ║  Multi-agent engineering for  ║${NC}"
  echo -e "${BLUE}  ║  Claude Code — Opus + Sonnet  ║${NC}"
  echo -e "${BLUE}  ╚═══════════════════════════════╝${NC}"
  echo ""
}

check_dependencies() {
  log "Checking dependencies..."

  if ! command -v claude &>/dev/null; then
    error "Claude Code CLI not found. Install it first: https://claude.ai/code"
  fi
  ok "Claude Code CLI found: $(claude --version 2>/dev/null | head -1 || echo 'version unknown')"

  if ! command -v node &>/dev/null; then
    warn "Node.js not found — hooks that use node will be skipped gracefully"
  else
    ok "Node.js found: $(node --version)"
  fi

  if ! command -v git &>/dev/null; then
    warn "Git not found — git-based features will not work"
  else
    ok "Git found: $(git --version)"
  fi
}

check_existing() {
  local target="$1"
  if [ -d "$target" ]; then
    warn "Existing .claude/ directory found at $target"
    read -r -p "  Merge Claudopus into it? Existing files will not be overwritten. [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      error "Install cancelled."
    fi
    MERGE_MODE=true
  else
    MERGE_MODE=false
  fi
}

install_to() {
  local target="$1"
  local label="$2"

  log "Installing Claudopus to $target ($label)..."

  if [ "$MERGE_MODE" = true ]; then
    # Merge mode — only copy files that don't already exist
    find "$SOURCE_DIR" -type f | while read -r src_file; do
      rel="${src_file#$SOURCE_DIR/}"
      dst_file="$target/$rel"
      if [ -f "$dst_file" ]; then
        warn "Skipping (exists): $rel"
      else
        mkdir -p "$(dirname "$dst_file")"
        cp "$src_file" "$dst_file"
        ok "Installed: $rel"
      fi
    done
  else
    # Fresh install — copy everything
    cp -r "$SOURCE_DIR" "$(dirname "$target")/$(basename "$target")"
    ok "Installed all Claudopus files"
  fi

  # Ensure memory and plans directories exist
  mkdir -p "$target/memory/plans"

  # Always update CLAUDOPUS_VERSION in settings.json if it exists
  if [ -f "$target/settings.json" ] && command -v node &>/dev/null; then
    node -e "
const fs = require('fs');
const s = JSON.parse(fs.readFileSync('$target/settings.json', 'utf8'));
if (s.env) s.env.CLAUDOPUS_VERSION = '$CLAUDOPUS_VERSION';
fs.writeFileSync('$target/settings.json', JSON.stringify(s, null, 2));
" 2>/dev/null || true
  fi
}

validate_install() {
  local target="$1"
  log "Validating install..."

  local required=(
    "CLAUDE.md"
    "settings.json"
    "agents/orchestrator.md"
    "agents/interviewer.md"
    "agents/planner.md"
    "agents/executor.md"
    "agents/reviewer.md"
    "agents/verifier.md"
    "skills/deep-interview.md"
    "skills/plan.md"
    "skills/build.md"
    "skills/review.md"
    "skills/verify.md"
    "skills/commit.md"
    "hooks/settings.json"
    "commands/start.md"
    "commands/plan.md"
    "commands/build.md"
    "commands/review.md"
    "memory/project.json"
  )

  local all_ok=true
  for f in "${required[@]}"; do
    if [ -f "$target/$f" ]; then
      ok "$f"
    else
      warn "Missing: $f"
      all_ok=false
    fi
  done

  if [ "$all_ok" = true ]; then
    ok "All required files present"
  else
    warn "Some files are missing — re-run install to add them"
  fi
}

print_next_steps() {
  local target="$1"
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║       Claudopus is ready to use        ║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
  echo ""
  echo "  Open your project in VS Code and start Claude Code."
  echo ""
  echo "  Commands:"
  echo "    /start   — begin a new task (full pipeline)"
  echo "    /plan    — generate a plan for a clear task"
  echo "    /build   — execute the current plan"
  echo "    /review  — audit current code"
  echo ""
  echo "  Agents will be available automatically."
  echo "  The orchestrator reads CLAUDE.md and routes your task."
  echo ""
  echo "  Installed to: $target"
  echo ""
}

# ── Main ──────────────────────────────────────────────────────────────────────

print_header

MODE="project"
CHECK_ONLY=false

for arg in "$@"; do
  case $arg in
    --global)   MODE="global" ;;
    --check)    CHECK_ONLY=true ;;
    --help|-h)
      echo "Usage: ./install.sh [--global] [--check]"
      echo ""
      echo "  (no args)   Install into current project (./.claude/)"
      echo "  --global    Install into user scope (~/.claude/)"
      echo "  --check     Validate an existing install"
      exit 0
      ;;
  esac
done

if [ "$MODE" = "global" ]; then
  TARGET="$HOME/.claude"
else
  TARGET="$(pwd)/.claude"
fi

if [ "$CHECK_ONLY" = true ]; then
  validate_install "$TARGET"
  exit 0
fi

check_dependencies
check_existing "$TARGET"
install_to "$TARGET" "$MODE"
validate_install "$TARGET"
print_next_steps "$TARGET"
