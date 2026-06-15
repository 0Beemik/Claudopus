# Changelog

All notable changes to Claudopus are documented here.

Format: [Semantic Versioning](https://semver.org)

---

## [1.1.0] — 2026-06-15

Build-power upgrade: stronger pre-planning, one model, smoother autonomy.

### Changed
- **All agents now run Claude Opus 4.8** (was Opus 4.6 / Sonnet 4.6). Tiered by effort: `max` for reasoning and review (orchestrator, interviewer, planner, reviewer), `high` for build and verify (executor, verifier). Single model, no Sonnet.
- **Entry command renamed `/start` → `/claudopus`.** All references updated.
- **Workflow lifecycle** is now `interview → pre-plan → plan → build → review → verify → ship`.
- `permissions.defaultMode: "acceptEdits"` added to `settings.json` so the pipeline runs without prompting on every edit; `bypassPermissions` documented as the sandboxed full-auto opt-in.

### Added
- **`pre-plan` skill** — the build-prep step between interview and plan. Phase A **Decide** (the `actions` framework) → Phase B **Recon** (line-precision audit of the chosen change against the real code → go/no-go + revision list). Callable whole or in parts. `/pre-plan` command added.
- **`actions` skill** — the rigid six-phase decision/diagnosis framework (Observe → Look Back → Look Around → Look Forward → Simulate → Act). Used as `pre-plan` Phase A and standalone for reactive bug-fixing.
- **TDD-first** discipline in the `executor` — write the failing test, watch it fail, then implement.
- **Verify-before-done** prime directive in the `verifier` — evidence, not assertions; never claim a pass you didn't run this session.
- **Strengthened security pass** in the `reviewer` — client/server gate parity, client-writable fields, secrets in client bundles, webhook idempotency, dependency vulnerabilities.
- **Real git-worktree parallelism** in the `orchestrator` — each parallel executor gets its own worktree; the verifier merges and prunes.

### Decision
- **Did not import the superpowers framework.** With `pre-plan` (`actions` + `recon`) in place, Claudopus's pre-planning is already stronger; only the two genuinely-missing principles (TDD-first, verify-before-done) were folded into agents. Keeps the toolset a tight, unified set rather than a sprawling collection.

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
