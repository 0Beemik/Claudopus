# Claudopus — Project State

## Last updated
2026-04-04

## Status
`complete — v1.0.0 ready for install`

## What was built

Full Claudopus `.claude/` system — 20 files across 6 directories plus install script and README.

### Files created (this session)
| File | Purpose |
|---|---|
| `.claude/CLAUDE.md` | Master identity, rules, agent routing table, git conventions |
| `.claude/settings.json` | Model config, bash permissions, hooks registration |
| `.claude/agents/orchestrator.md` | Opus 4.6 — routes tasks, coordinates all agents |
| `.claude/agents/interviewer.md` | Opus 4.6 — Socratic clarification before planning |
| `.claude/agents/planner.md` | Opus 4.6 — converts requirements to executable specs |
| `.claude/agents/executor.md` | Sonnet 4.6 — parallel implementation worker |
| `.claude/agents/reviewer.md` | Opus 4.6 — correctness, security, SOLID audit |
| `.claude/agents/verifier.md` | Sonnet 4.6 — tests, build validation, commit |
| `.claude/skills/deep-interview.md` | Clarification workflow |
| `.claude/skills/plan.md` | Spec generation process |
| `.claude/skills/build.md` | Implementation loop and standards |
| `.claude/skills/review.md` | Review checklist |
| `.claude/skills/verify.md` | Test and ship checklist |
| `.claude/skills/commit.md` | Conventional commit format |
| `.claude/hooks/settings.json` | SubagentStop, Stop, PreToolUse handlers |
| `.claude/commands/start.md` | /start — full pipeline entry point |
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
- Opus 4.6 for reasoning agents (orchestrator, interviewer, planner, reviewer)
- Sonnet 4.6 for execution agents (executor, verifier)
- Zero external dependencies — 14 markdown + 2 JSON + 1 bash script
- Project-scoped install recommended; global install supported

## Next actions
1. `git init` and push to GitHub as a standalone repo
2. Add `memory/project.json` entries for your specific project stack
3. Run `/start [your first task]` in Claude Code
4. Optionally: append project-specific rules to `CLAUDE.md`

## Known open items
- `install.sh` curl one-liner URL needs real repo path once published
- `settings.json` hooks use inline node — could be extracted to separate `.js` files for readability in a v1.1
- No Windows install path yet (bash script only) — PowerShell variant is a future task
