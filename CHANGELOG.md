# Changelog

All notable changes to Claudopus are documented here.

Format: [Semantic Versioning](https://semver.org)

---

## [1.0.0] — 2026-04-04

Initial release.

### Added
- `orchestrator` agent — Opus 4.6, routes and coordinates all agents
- `interviewer` agent — Opus 4.6, Socratic requirement clarification
- `planner` agent — Opus 4.6, converts requirements to executable specs
- `executor` agent — Sonnet 4.6, parallel implementation worker
- `reviewer` agent — Opus 4.6, correctness, security, SOLID audit
- `verifier` agent — Sonnet 4.6, tests, validation, commit
- `deep-interview` skill — clarification workflow
- `plan` skill — spec generation process
- `build` skill — implementation loop and code standards
- `review` skill — review checklist
- `verify` skill — test and ship checklist
- `commit` skill — conventional commit format
- `/start`, `/plan`, `/build`, `/review` commands
- `hooks/settings.json` — SubagentStop, Stop, PreToolUse handlers
- `memory/project.json` — persistent project context scaffold
- `install.sh` — project and global install with merge mode and validation
- GitHub Actions validation workflow
- MIT License

### Architecture
- Native Claude Code subagent system — no external orchestration layer
- Anthropic-only model routing — Opus 4.6 for reasoning, Sonnet 4.6 for execution
- Zero external dependencies
