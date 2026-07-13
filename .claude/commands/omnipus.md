# Omnipus

Begin any goal with Omnipus — the Fable-orchestrated, Opus-built engineering
system. One command that understands the task, then drives it to shipped-and-
proven through a real fleet of separately-spawned agents.

`/omnipus <any goal>`

## What happens

Omnipus loads its skill and you (the main session, running Claude Fable 5)
become the **orchestrator**. It scales the ceremony to the task, then runs the
pipeline — spawning each gate as a real agent on its assigned model:

1. **Ω0 Triage** — trivial / non-executable / substantial; states the lane.
2. **Interview → Pre-plan** (`interviewer`, `planner` on Fable) — lock intent
   and acceptance criteria. Autonomy is *earned here*: it drives unattended only
   once it can state what "done" means.
3. **Ω1 Plan** (`planner`, Fable) → **Ω2 Build** (`executor`(s), Opus).
4. **Ω3 Verify** (`verifier`, Opus) — runs it, checks against acceptance
   criteria, PASS + evidence or FAIL + error.
5. **Ω4 Review** (`reviewer`, Fable) → **Ω5 Audit** (`auditor`, Fable) —
   independent hostile review, then altitude sign-off.
6. **Ω6 Reconcile** — fix confirmed findings, re-verify, bounded by a circuit
   breaker (max 3 cycles → escalate).
7. **Ω7 Deliver** — WHAT / PROOF (quoted agent output + run-ledger) / RESIDUAL,
   and writes learnings back to memory.

## What makes it Omnipus, not just a prompt

- **It spawns — it doesn't impersonate.** Verify and review are done by agents
  that never read the build reasoning. The `SubagentStop` run-ledger records
  that they actually fired.
- **Fable plans, Opus builds.** The tiering is enforced by delegating to agents
  that carry their own `model:`.
- **It reaches for the whole toolbox.** Any Tier-1 slash command or tool a phase
  needs — `/code-review`, `/security-review`, `/verify`, `/dataviz`,
  `/deep-research`, `/schedule`, and more (`references/commands.md`).
- **It's autonomous, safely.** Auto-mode with a circuit breaker, a learning
  memory, context governance, and opt-in real parallelism + push escalation.

## Usage

```
/omnipus build a user profile page with avatar upload
/omnipus add rate limiting to the API
/omnipus research and recommend a caching strategy for the jobs endpoint
/omnipus fix the login redirect bug
```

## Running with minimal interruption

`settings.json` ships `"permissions": { "defaultMode": "acceptEdits" }` — edits
auto-approve and common build commands auto-approve via the allow-list, while
the `deny` list + `bash-safety` hook still guard destructive commands. For a
fully hands-off run in a throwaway workspace: `claude --permission-mode
bypassPermissions` (disables all checks including deny — use only where a mistake
can't hurt anything real).

## Short-circuits

- `/plan` — plan a clear task without building (still pre-plans non-trivial work).
- `/build` — execute an existing plan from `memory/project.json`.
- `/review` — run the reviewer on existing code.
- `/pre-plan` — decide + recon before a plan.
