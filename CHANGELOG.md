# Changelog

## Rebrand — Claudopus is now Omnipus (2026-07-09)

This project has been rebranded from **Claudopus** to **Omnipus**, fusing
the original multi-agent architecture with the Omni phase pipeline.
The complete pre-rebrand state is preserved on the `claudopus-original` branch:
https://github.com/0Beemik/Claudopus/tree/claudopus-original

---


All notable changes to Claudopus are documented here.

Format: [Semantic Versioning](https://semver.org)

---

## [1.2.0] — 2026-07-02

Model tiering: the reasoning core moves to Claude Fable 5, and a final audit gate is added.

### Changed
- **Two-model tiering (was single-model Opus 4.8).** The reasoning and judgment core now runs **Claude Fable 5** — Anthropic's most capable model — tiered by stakes: `effort: max` for the run-defining stages (**orchestrator, planner, auditor**) and `effort: medium` for the focused Fable work (**interviewer, reviewer**). The high-volume build and verify path stays on **Claude Opus 4.8** at `effort: high`: **executor, verifier**. Fable 5 sits where long-horizon coordination and correctness pay off; Opus 4.8 sits where throughput and cost efficiency matter.
- **Main-session default model → `claude-fable-5`** in `settings.json` (the top-level session acts as the orchestrator).
- **Workflow lifecycle** is now `interview → pre-plan → plan → build → review → verify → audit → ship` — the audit gate is added before ship.
- **Fable-tuned prompts for the reasoning core.** Following Anthropic's Fable 5 guidance, the five Fable agents (and `CLAUDE.md`) gained a **Working on Claude Fable 5** section and were de-prescribed: steer with goals and constraints, not step-by-step scripts or "CRITICAL / YOU MUST" pressure (which Fable over-applies). Added the tested behavioral guardrails per role — act-when-ready / recommend-don't-survey, simplest-thing-that-works, evidence-not-assertion, assess-before-acting, async sub-agent delegation (orchestrator), and the code-review **report-everything-with-confidence, filter-downstream** correction (reviewer, auditor). Substantive domain checklists (security, SOLID, plan structure) were kept. Executor and verifier prompts are unchanged (Opus 4.8).

### Added
- **`auditor` agent (Fable 5, `effort: max`).** The final independent sign-off before shipping — after the reviewer approves and the verifier validates. It judges the change as a whole: intent fidelity, whole-system coherence, regression surface, production readiness, and gate integrity. Read-only; it never modifies code. Registered in CI required-files and the installer manifest.

### Note
- **Fable 5 requires 30-day data retention** and is not available under zero data retention (ZDR). Organizations on ZDR must enable retention for the Fable-tier agents, or those agents will error. Opus-tier agents (executor, verifier) are unaffected.

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
