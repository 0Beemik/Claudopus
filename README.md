# Omnipus

**One command that acts decisively, then earns the word "done" with independent proof.**

Most AI coding help stops at "this should work." Omnipus doesn't. It plans, builds, and then
hands the work to *separate* agents that run it and tear it apart — before it ever tells you it's
finished. You get the speed of a single agent that just does the thing, plus the accountability of
a team that checks it. `/omnipus <goal>` — that's the whole interface.

It's the fusion of two ideas:

- **Omni** — a disciplined phase pipeline (plan → build → verify → review → deliver) that keeps a
  single agent honest about its own process.
- **Claudopus** — separation of powers: the reviewer is a *different* agent, so it can't inherit the
  builder's blind spots.

Omnipus takes the best of both and drops the ceremony neither needed.

## The core idea

> The builder does not certify its own build.

Planning and building are the main agent's job. **Verification and review are handed to
independently-spawned subagents** — a reviewer that never read the builder's reasoning can't be
talked into agreeing with it. That's the difference between "I'm confident this works" and "a
separate agent ran it and here's the output."

This is a discipline, enforced by design, not by wishful thinking: the pipeline is built so the
fastest path to "done" *runs through* the gates, not around them. And it's deliberately honest about
where independence comes from — a runnable check (Ω3) is stronger than any second opinion, so
Omnipus leans on evidence first and judgment second. That's not a limitation; it's the point. Proof
beats persuasion every time.

## Operating stance — autonomous by default

Omnipus is built to finish things, not to ask permission to start them.

- **Auto mode.** It acts and drives to completion. Normal decisions get made — best option, noted, keep moving.
- **Evidence, not interrogation.** The gate is a subagent running your code, not a wall of questions.
- **It stops for exactly one class of thing:** the irreversible and the destructive — deleting data
  it didn't create, external sends, or anything a project's `CLAUDE.md` explicitly gates. There, and
  only there, it asks first.
- **Guardrails are a feature, not friction.** "Autonomous" narrows what it *asks*, never what it
  *checks*. Rework is what actually costs you time — and Omnipus is built to not need it.

## The pipeline

| Phase | Who runs it | Job |
|---|---|---|
| Ω1 PLAN | main agent | goal, steps, files, biggest risk |
| Ω2 BUILD | main agent | smallest complete version, then extend |
| Ω3 VERIFY | **spawned subagent** | run it + check against acceptance criteria; PASS + evidence or FAIL + error |
| Ω4 REVIEW | **spawned subagent** | independent hostile review: bugs, security, simplification |
| Ω5 RECONCILE | main agent | fix confirmed findings, re-verify |
| Ω6 DELIVER | main agent | WHAT / PROOF / RESIDUAL, visualize if data |

Ceremony scales to the task: trivial or non-executable work skips the subagent gates — stated out
loud, never silently.

## Install

Global (every project can call it), run from the repo root:

```bash
mkdir -p ~/.claude/skills
cp -rT .claude/skills/omnipus ~/.claude/skills/omnipus
```

`cp -rT` copies *into* the target instead of nesting a second `omnipus/` inside it. Then run
`/reload-skills` in any Claude Code session and invoke with `/omnipus <goal>`.

## Lineage

- **Omni** — the single-agent phase pipeline.
- **Claudopus** — the multi-agent tiered system this repo grew from (preserved in full on the
  [`claudopus-original`](https://github.com/0Beemik/Omnipus/tree/claudopus-original) branch).

Omnipus keeps Omni's light footprint and Claudopus's separation of powers. It doesn't promise
magic — it promises *proof*, and that turns out to be the more useful thing.
