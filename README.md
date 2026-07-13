# Omnipus

**One command that understands the task, then drives it to shipped-and-proven — with a real fleet of agents that verify and review the work before it's called done.**

Most AI coding help stops at "this should work." Omnipus doesn't. A **Claude Fable 5**
orchestrator understands your goal, plans it, and delegates the build to **Claude Opus 4.8** —
then hands the result to *separately-spawned* agents that run it and tear it apart before it ever
says "finished." You get the speed of an agent that just does the thing, plus the accountability of
a team that checks it. `/omnipus <goal>` — that's the whole interface.

It's the working fusion of two ideas:

- **Omni** — a disciplined phase pipeline (triage → plan → build → verify → review → deliver) that
  keeps the process honest.
- **Claudopus** — separation of powers: verification and review are done by *different* agents on
  their own models, so they can't inherit the builder's blind spots.

## The core idea

> The builder does not certify its own build — and you can prove it did the delegation.

Planning and building are one thing; **verification and review are handed to independently-spawned
agents.** A reviewer that never read the builder's reasoning can't be talked into agreeing with it.
And every spawn is written to a **run-ledger**, so "a separate agent reviewed this" is *auditable*,
not asserted. That last part matters: this project was rebuilt precisely because an earlier version
*described* spawning agents in prose but never actually wired to them.

## What makes it work (the mechanism, not a vibe)

- **Fable plans, Opus builds.** The main session runs Fable 5 and acts as orchestrator; it spawns
  the fleet by `subagent_type`, and each agent carries its own `model:` — so delegating to the right
  agent is what puts the right model on the job.
- **It spawns, it doesn't impersonate.** Each gate is a real `Agent` call. The `SubagentStop` hook
  logs it to `~/.claude/omnipus-ledger.jsonl`.
- **Autonomy is earned.** It runs unattended *once it understands the task* — interview and pre-plan
  lock intent and acceptance criteria first. Then it drives, stopping only for the irreversible.
- **Safe auto-mode.** A circuit breaker bounds retries (3 cycles → escalate), context governance
  keeps long runs alive, and a learning memory writes failures back so it improves across runs.
- **The whole toolbox.** In any phase it reaches for the right slash command or tool — `/code-review`,
  `/security-review`, `/verify`, `/dataviz`, `/deep-research`, `/schedule`, and more.

## The pipeline

| Phase | Runs as | Model | Job |
|---|---|---|---|
| Ω0 TRIAGE | orchestrator | Fable | trivial / non-executable / substantial — pick the lane |
| INTERVIEW | spawn `interviewer` | Fable | resolve only build-deciding ambiguity |
| PRE-PLAN | spawn `planner` | Fable | decide the approach, recon it against real code |
| Ω1 PLAN | spawn `planner` | Fable | executable plan: goal, files, risk, done-criteria |
| Ω2 BUILD | spawn `executor`(s) | Opus | implement; parallel worktrees opt-in |
| Ω3 VERIFY | spawn `verifier` | Opus | run it + check acceptance criteria; PASS+evidence / FAIL+error |
| Ω4 REVIEW | spawn `reviewer` | Fable | independent hostile review, ranked |
| Ω5 AUDIT | spawn `auditor` | Fable | altitude sign-off: intent, coherence, regressions |
| Ω6 RECONCILE | orchestrator | Fable | fix findings, re-verify — bounded by the circuit breaker |
| Ω7 DELIVER | orchestrator | Fable | WHAT / PROOF / RESIDUAL; visualize if data; write learnings to memory |

Ceremony scales to the task: trivial or non-executable work skips the fleet gates — stated out loud,
never silently.

## Opt-in power features

- **Real parallelism** — each independent executor gets its own git worktree, run concurrently.
- **Escalation reach** — a push notification when a long/unattended run needs you or finishes.

Both are offered, not forced — Omnipus asks once per run.

## Install

**Per-project (recommended)** — installs the whole system (skill + fleet + commands + hooks +
settings) into the current repo:

```bash
./install.sh --project
```

**Global** — installs the additive pieces (agents, commands, skills) into `~/.claude`. It will *not*
overwrite your global `settings.json` or `CLAUDE.md`; it prints how to merge the model tiering and
run-ledger hooks yourself:

```bash
./install.sh
```

Then run `/reload-skills` in Claude Code and invoke with `/omnipus <goal>`.

Omnipus is a *system*, not a lone skill — the skill delegates to the agent fleet and relies on
`settings.json` for models, hooks, and permissions. That's why project scope is recommended.

## Staying current

The command and tool maps in `.claude/skills/omnipus/references/` are snapshots of Anthropic's docs.
`install.sh` checks their age against `version.json`; past the 60-day interval it fetches fresh docs
and drops a `SYNC_PENDING` marker, and Omnipus reconciles the maps on its next run. Bash detects,
the model reconciles — the only failure mode is the docs ceasing to exist, and even then it falls
back to the last snapshot. See `references/SYNC.md`.

## Before you run it

- **Fable 5 requires 30-day data retention** and is not available under zero data retention (ZDR).
  On ZDR orgs the Fable-tier agents (orchestrator, planner, reviewer, auditor) will error; the
  Opus-tier build/verify agents are unaffected.

## Lineage

- **Omni** — the single-agent phase pipeline.
- **Claudopus** — the multi-agent tiered fleet this grew from (preserved on the
  [`claudopus-original`](https://github.com/0Beemik/Omnipus/tree/claudopus-original) branch).

Omnipus keeps Omni's phase discipline and Claudopus's separation of powers, wired so the fastest
path to "done" runs *through* the gates — and proves it did. It doesn't promise magic; it promises
*proof*, which turns out to be the more useful thing.
