# Pre-plan

Decide an approach and recon it against the real code before a plan is written. The build-prep step that makes the plan surgical instead of speculative.

Use this on any non-trivial change, or whenever you want to know "what will this actually touch / break" before committing to a plan.

## What happens

Runs the **`pre-plan`** skill — two phases, callable whole or in parts:

1. **Decide** (the `actions` framework) — settles the right approach, weighed across past / present / future, with a one-way vs two-way door verdict.
2. **Recon** — a read-only, line-precision audit of that approach against the real code: confirms field paths and signatures, surfaces pre-existing issues, builds the cross-step interaction matrix, and ends with a numbered go/no-go revision list.

The output is a **validated brief** — hand it to the planner (`/plan`) and the revisions get folded in.

## Usage

```
/pre-plan add a password reset flow using the existing mailer
/pre-plan recon only: the auth refactor plan in memory/plans/auth.md
/pre-plan decide only: should goals cache per-user or per-goal?
```

- **whole** — decide then recon (the default, before a new plan)
- **recon only** — when the *what* is settled and you only need "what will it touch" (e.g. validating an existing plan)
- **decide only** — a pure judgment call with no code to audit yet

## After pre-plan

No code is written. Review the brief, then run `/plan` (or `/claudopus`) to turn it into an implementation plan — or `/build` if a plan already exists and the recon only refined it.
