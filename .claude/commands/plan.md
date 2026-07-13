# Plan

Generate an implementation plan for a well-defined task. Use this when requirements are already clear and you want to skip the interview phase and go straight to planning.

## What happens

1. The planner agent reads the codebase and your task
2. Runs **`pre-plan`** on non-trivial changes — decides the approach (`actions`) then recons it against the real code at line precision → a validated revision list
3. Produces a structured plan in `memory/plans/` with the recon revisions folded in
4. Updates `memory/project.json`
5. Reports the plan for your review before any code is written

Run `/pre-plan` on its own first if you want to see the decide/recon brief before a plan is written.

## Usage

```
/plan add a password reset flow using sendgrid
/plan refactor the database layer to use a repository pattern
/plan create a caching layer for the jobs API endpoint
```

## When to use `/plan` vs `/omnipus`

Use `/plan` when:
- Requirements are completely clear
- You want to review the plan before committing to implementation
- You want a plan for discussion without immediately building

Use `/omnipus` when:
- Requirements may need clarification
- You want the full pipeline from task to shipped code

## After the plan is produced

Review it. If it looks right, run `/build` to execute it.
If something needs adjusting, tell the planner what to change before building.
