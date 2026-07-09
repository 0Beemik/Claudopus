# Omnipus

**Omni × Claudopus** — one command that acts decisively, then proves it with independent agents.

Omni gave a single agent a disciplined phase pipeline (plan → build → verify → review → deliver).
Claudopus split the work across *separate* agents so the reviewer can't share the builder's blind spots.
Omnipus fuses them: a single `/omnipus <goal>` command that the main agent drives, but whose
**VERIFY** and **REVIEW** phases are handed to **independently-spawned subagents**.

## The core idea (and its honest limit)

> The builder does not certify its own build.

Planning and building are done by the main agent. Verification and review are handed to subagents
spawned via the Agent tool — a reviewer that never read the builder's transcript can't be fooled by
its written rationalizations.

**But be honest about what that buys.** A SKILL.md is a prompt, not an enforcer: the same agent
decides to spawn the reviewer and reads its report, so this is a *discipline that raises the odds*
of independent checking, not a structural guarantee. And a spawned reviewer is the *same model on
the same code* — free of the transcript's blind spots, not the model's. For high-stakes correctness
the real independence is a **runnable external check** (Ω3) and, where it matters, a **different-model
reviewer**. Prefer machine evidence over a second opinion.

## Operating stance — autonomous by default

- **Auto mode.** Acts without asking and drives to completion. Normal forks are
  resolved by picking the best option and noting it.
- **Gate on machine evidence, not on questions** — the check is a subagent running the code.
- **Absolute-permission stops only:** irreversible/destructive actions, and anything
  `CLAUDE.md` gates (installs, downloads, model swaps, root steps). Those need an explicit "go."
- **Guardrails stay.** "Autonomous" narrows what it *asks*, never what it *checks*. Rework, not
  verification, is what actually costs time.

## The pipeline

| Phase | Who runs it | Job |
|---|---|---|
| Ω1 PLAN | main agent | goal, steps, files, biggest risk |
| Ω2 BUILD | main agent | smallest complete version, then extend |
| Ω3 VERIFY | **spawned subagent** | run it + check against acceptance criteria; PASS + evidence or FAIL + error |
| Ω4 REVIEW | **spawned subagent** | independent hostile review: bugs, security, simplification |
| Ω5 RECONCILE | main agent | fix confirmed findings, re-verify |
| Ω6 DELIVER | main agent | WHAT / PROOF / RESIDUAL, visualize if data |

Trivial or non-executable tasks scale the subagent gates down (stated, never silent).

## Install

Global (every project can call it), run from the repo root:

```bash
mkdir -p ~/.claude/skills
cp -rT .claude/skills/omnipus ~/.claude/skills/omnipus
```

`cp -rT` copies *into* the target instead of nesting a second `omnipus/` inside it if the
directory already exists. Then in any session: `/reload-skills`, and invoke with `/omnipus <goal>`.

## Lineage

- **Omni** — `../omni-SKILL.md`, the single-agent phase pipeline.
- **Claudopus** — https://github.com/0Beemik/Claudopus, the seven-agent tiered system.

Omnipus keeps Omni's light footprint and Claudopus's separation of powers, and drops the theater
either one didn't need.
