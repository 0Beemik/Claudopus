# Claudopus (legacy alias → /omnipus)

> **This is a legacy alias.** The current entry point is **`/omnipus`**, which
> runs the same fleet through the full Ω-pipeline (triage → interview →
> pre-plan → plan → build → verify → review → audit → reconcile → deliver) with
> the run-ledger, circuit breaker, and learning memory. Prefer `/omnipus`; this
> command is kept so existing muscle memory and docs still work.

Begin a new task. Triggers the full workflow: interview → pre-plan → plan → build → review → verify → audit → ship.

Use this when you have a new feature, fix, or task and want the full pipeline.

## What happens

1. The orchestrator reads your task and existing project memory
2. If requirements need clarification, the interviewer agent runs first
3. **Pre-plan** (the `pre-plan` skill): the planner *decides* the right approach (the `actions` framework — past/present/future) then *recons* it against the real code at line precision → a validated brief
4. From that brief, the planner produces an implementation plan
5. Executor agents implement the plan (TDD-first, in parallel where possible)
6. The reviewer audits the output (correctness, security, SOLID)
7. The verifier runs tests, confirms with evidence, and ships

## Usage

```
/claudopus build a user profile page with avatar upload
/claudopus add rate limiting to the API
/claudopus fix the login redirect bug
```

## Provide as much context as you have

The more you give, the less time the interview phase takes. You can include:
- What it should do
- Who uses it
- What it connects to
- Any constraints or preferences
- What done looks like to you

The orchestrator will use everything you provide and only ask what is genuinely missing.

## Running with minimal interruption

Claudopus ships with `"permissions": { "defaultMode": "acceptEdits" }` in `settings.json`: file edits auto-approve and the common build commands auto-approve via the bash allow-list, while the `deny` list + `bash-safety` hook still guard dangerous commands. That's the smooth default — the pipeline runs without prompting on every edit.

For a **fully autonomous, hands-off run** (no prompts at all), launch in a sandboxed/throwaway workspace with:

```
claude --permission-mode bypassPermissions
```

`bypassPermissions` disables **all** permission checks — including the deny list. Use it only where a mistake can't hurt anything real (a container, a scratch clone). There is no `auto` mode; the valid values are `default`, `plan`, `acceptEdits`, `dontAsk`, `bypassPermissions`.
