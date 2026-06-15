# Claudopus — Project State

## Last updated
2026-06-15

## Status
`v1.1.0 — build-power upgrade shipped`

## What changed in v1.1.0
- All agents → **Claude Opus 4.8**, tiered by effort (`max` reasoning/review, `high` build/verify). No Sonnet.
- Entry command **`/start` → `/claudopus`**; lifecycle now `interview → pre-plan → plan → build → review → verify → ship`.
- New **`pre-plan`** skill (Decide via `actions` → Recon) + **`actions`** skill; `/pre-plan` command; planner runs pre-plan before writing the spec.
- **TDD-first** (executor), **verify-before-done** (verifier), **stronger security pass** (reviewer), **git-worktree parallelism** (orchestrator).
- `permissions.defaultMode: "acceptEdits"`; `bypassPermissions` documented as the sandboxed full-auto opt-in.
- Deliberately did **not** import the superpowers framework (pre-plan already covers it; only TDD + verify principles folded in).

## What was built (v1.0.0 baseline)

Full Claudopus `.claude/` system — now 24 files across 6 directories plus install script and README.

### Files created (this session)
| File | Purpose |
|---|---|
| `.claude/CLAUDE.md` | Master identity, rules, agent routing table, git conventions |
| `.claude/settings.json` | Model config, bash permissions, hooks registration |
| `.claude/agents/orchestrator.md` | Opus 4.8 — routes tasks, coordinates all agents |
| `.claude/agents/interviewer.md` | Opus 4.8 — Socratic clarification before planning |
| `.claude/agents/planner.md` | Opus 4.8 — converts requirements to executable specs |
| `.claude/agents/executor.md` | Opus 4.8 — parallel implementation worker |
| `.claude/agents/reviewer.md` | Opus 4.8 — correctness, security, SOLID audit |
| `.claude/agents/verifier.md` | Opus 4.8 — tests, build validation, commit |
| `.claude/skills/deep-interview.md` | Clarification workflow |
| `.claude/skills/plan.md` | Spec generation process |
| `.claude/skills/build.md` | Implementation loop and standards |
| `.claude/skills/review.md` | Review checklist |
| `.claude/skills/verify.md` | Test and ship checklist |
| `.claude/skills/commit.md` | Conventional commit format |
| `.claude/skills/actions.md` | **(v1.1)** Rigid 6-phase decision/diagnosis framework |
| `.claude/skills/pre-plan.md` | **(v1.1)** Decide (`actions`) → Recon build-prep skill |
| `.claude/hooks/settings.json` | SubagentStop, Stop, PreToolUse handlers |
| `.claude/commands/claudopus.md` | /claudopus — full pipeline entry point (was /start) |
| `.claude/commands/pre-plan.md` | **(v1.1)** /pre-plan — decide + recon before a plan |
| `.claude/commands/plan.md` | /plan — planning without building |
| `.claude/commands/build.md` | /build — execute current plan |
| `.claude/commands/review.md` | /review — standalone code review |
| `.claude/memory/project.json` | Persistent project context scaffold |
| `install.sh` | Installer — project or global scope |
| `README.md` | Full documentation |

## Agents used
- None (planning and scaffolding session)

## Current branch / worktree
- No git repo initialised — files ready to be committed to a new repo

## Architecture decisions
- Native Claude Code subagent system — no external orchestration layer
- One model — Opus 4.8 — tiered by effort: `max` (orchestrator, interviewer, planner, reviewer), `high` (executor, verifier)
- Pre-planning is the differentiator: `pre-plan` (decide + line-precision recon) runs before any non-trivial plan
- Superpowers framework deliberately NOT imported — kept a tight, unified set; only TDD-first + verify-before-done principles folded in
- Zero external dependencies — markdown + JSON + 1 bash script
- Project-scoped install recommended; global install supported

## Next actions
1. Smoke-test `/claudopus [a real task]` end-to-end and confirm the planner actually runs `pre-plan`
2. Update `install.sh` file manifest if the new skills/commands aren't picked up
3. Add `memory/project.json` entries for the target project stack
4. Optionally: extract the inline-node hooks to `.js` files (v1.0 open item)

## Known open items
- `install.sh` curl one-liner URL needs real repo path once published
- `settings.json` hooks use inline node — could be extracted to separate `.js` files for readability in a v1.1
- No Windows install path yet (bash script only) — PowerShell variant is a future task
