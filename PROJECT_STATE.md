# Omnipus — Project State

## Last updated
2026-07-12

## Status
`v2.0.0 — the Fable orchestrator actually drives the Claudopus fleet`

## What changed in v2.0.0
The 2026-07-09 rebrand fused Omni + Claudopus in name but shipped a lone
`skills/omnipus/SKILL.md` that *described* spawning agents without wiring to the
fleet — so it ran single-threaded, lost the Fable/Opus tiering, and the
installer only shipped the skill. This release makes the fusion real.

- **SKILL.md rewritten** to drive the fleet: every Ω-phase is an explicit `Agent`
  spawn by `subagent_type` on its model (planner/reviewer/auditor → Fable 5,
  executor/verifier → Opus 4.8). Hedging prose removed.
- **Full lifecycle:** Ω0 triage → interview → pre-plan → plan → build → verify →
  review → audit → reconcile → deliver.
- **New principles baked in:** autonomy-earned-by-understanding, circuit breaker
  (≤3 verify→fix cycles → escalate), run-ledger observability, learning memory
  (`failure_patterns`), context governance, whole-toolbox Tier-1/2 command map.
- **Opt-in power features:** worktree parallelism + push-notification escalation.
- **Doc self-sync:** `version.json` + `references/SYNC.md`; `install.sh` detects
  staleness (60-day interval) and fetches fresh docs, orchestrator reconciles.
- **`install.sh`** now ships the whole `.claude/` system; `--project` recommended.
- **Fixed latent bug:** `settings.json` referenced `on-stop.js`/`bash-safety.js`
  that were never shipped → hooks are now self-contained inline; ledger path
  renamed to `~/.claude/omnipus-ledger.jsonl`; env → `OMNIPUS_VERSION`.
- **New `/omnipus` command** + **CI pipeline self-test** that fails if the skill
  stops referencing the real fleet (guards against the original regression).

## Files touched (this session)
| File | Change |
|---|---|
| `.claude/skills/omnipus/SKILL.md` | Full rewrite — fleet-driving Ω-pipeline |
| `.claude/skills/omnipus/references/commands.md` | New — Tier-1/2 command map |
| `.claude/skills/omnipus/references/tools.md` | New — tool map |
| `.claude/skills/omnipus/references/SYNC.md` | New — self-sync protocol |
| `.claude/skills/omnipus/version.json` | New — sync manifest |
| `.claude/commands/omnipus.md` | New — `/omnipus` entry point |
| `.claude/CLAUDE.md` | Rebrand + new principles (autonomy/circuit-breaker/ledger/memory) |
| `.claude/settings.json` | Self-contained ledger hooks; `OMNIPUS_*` env |
| `.claude/hooks/settings.json` | Mirrored ledger hooks |
| `.claude/memory/project.json` | Added `failure_patterns` |
| `install.sh` | Ship whole system + doc self-sync detector |
| `.github/workflows/validate.yml` | Rebrand + pipeline wiring self-test |
| `.gitignore` | Ignore sync artifacts |
| `README.md`, `CHANGELOG.md`, `PROJECT_STATE.md` | Docs |

## Architecture decisions
- Main session = Fable 5 orchestrator (option "a"): holds the routing table +
  `Agent` tool, spawns the fleet directly. No separate orchestrator-spawns-fleet
  hop (avoids fragile nested delegation).
- Full Claudopus lifecycle kept (interview + pre-plan) as the substantial-lane
  default; Omni's task-scaling triage decides the lane.
- Omnipus's own optimizations folded in, not lost: phase-gating, auto-mode,
  non-executable handling, evidence discipline, DELIVER contract.
- Bash detects doc staleness; the model reconciles the maps (a pure-bash
  doc→prompt update is impossible).
- Command control split: Tier-1 invokable vs Tier-2 recommend-only — honest
  about what the model can actually fire.

## Next actions
1. Smoke-test `/omnipus [a real task]` end-to-end; confirm the ledger records the
   fleet spawning and the models are tiered as expected.
2. Confirm `install.sh --project` and the doc-sync date math on a real machine
   (GNU + BSD date paths).
3. Consider the optional always-on `/schedule` sync routine (needs Pro/Max).

## Known open items
- Nested subagent spawning (orchestrator-as-subagent spawning the fleet) is
  deliberately avoided; if Claude Code hardens it later, revisit.
- Windows install path is still bash-only (PowerShell variant is future work).
