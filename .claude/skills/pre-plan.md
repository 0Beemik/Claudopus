---
name: pre-plan
description: The build-prep skill that runs between interview and plan on any non-trivial change. Decides the right approach, then recons it against the real code at line precision so the plan is surgical. Invoke before finalising a plan, or when the user says "audit", "deep dive", "what could break", "what will this touch", or before any production-critical change. Run whole, or just the recon, or just the decide.
---

# Pre-plan

The bridge between "we know what we want" and "here is the plan." It produces a **validated brief** the planner turns into an implementation plan — so the plan is grounded in the actual code, not assumptions.

Two phases. **Run the whole thing, or call either phase on its own:**

- **Phase A — Decide** — *what is the right thing to do?* Uses the `actions` framework (past / present / future). Skip when the *what* is already settled and you only need to know what it touches.
- **Phase B — Recon** — *what will doing it actually touch or break?* A read-only, line-precision audit of the chosen change against the real code. Skip only for trivial changes.

Output of both → a brief with: the chosen approach, the files/lines it touches, the breakpoints, and a numbered revision list. Hand that to the **planner**.

## When to use

- Before writing or revising a plan for a non-trivial change (the default pre-plan path)
- When the user says "audit", "deep dive", "recon", "what would this touch", "what could break"
- When a plan exists but hasn't been validated against the actual code → run **Phase B only**
- A pure judgment call with no code to audit yet → run **Phase A only**
- Production-critical work, or anywhere a regression is unacceptable

## When NOT to use

- Single-file edits or trivial additions — go straight to the change
- Pure exploration ("what does this do?")
- Requirements still vague — run the interviewer first

---

## Phase A — Decide

**REQUIRED SUB-SKILL:** Use the `actions` skill. Work its six phases (Observe → Look Back → Look Around → Look Forward → Simulate → Act-clearance) to land on a single chosen approach with a one-way/two-way door verdict.

The output you carry into Phase B:

```
## Chosen approach
[One paragraph: what we will do and why it beat the alternatives]

## Constraints that must hold
- [Contracts, schemas, behaviours that must not change]

## Open risks to confirm against the code
- [The assumptions Phase B must verify]
```

If Phase A says RECONSIDER, stop — don't recon an approach you've already rejected.

---

## Phase B — Recon

Reconnaissance before the operation. A read-only simulation that walks the chosen change against the real code, line by line, before any plan-writing or code-writing. Its job is to enable a surgical implementation — not to admire the problem.

### The non-negotiables

Skip any of these and the output is a guess.

1. **Read actual code, not summaries.** Use Read on every file in scope. Quote line numbers. grep tells you *where* to look; Read tells you *what's there*.
2. **Cite `path:line` in every finding.** A finding without a line number is unverifiable.
3. **Verify the approach's claims against the code.** When you assume "X happens at line Y", confirm it. Assumptions drift from reality.
4. **Check pattern conformance.** Read `.claude/rules/*` (or equivalent project conventions) and `CLAUDE.md` before judging — naming, error handling, dependency-injection style, the project's idioms.
5. **Hunt for cross-step coupling.** Each proposed change must dovetail with the next. Build the interaction matrix explicitly.
6. **Surface pre-existing issues found along the way.** Categorise each: must-fix-in-scope, defer-and-document, or ignore. Don't let issues silently hitch a ride on the new work, and don't let them silently expand scope.
7. **End with a go/no-go and a concrete revision list.** Numbered, one-line each, ready to fold into the plan.

### Output structure (use exactly)

1. **Approach corrections discovered** — what the chosen approach got wrong about the actual code. Each: *We assumed X — code at `path:line` shows Y — fix.*
2. **Pre-existing issues this work MUST fix** — blockers the change would inherit. Each: severity, `path:line`, why it blocks, fix, which step absorbs it.
3. **Pre-existing issues NOT in scope (deferred)** — one-line entries suitable for `PROJECT_STATE.md` known-issues. Prevents silent scope creep.
4. **Step-by-step / area-by-area simulation** — for each change area: files touched (`path:line` per edit), the few critical signatures/lines where transactionality or atomicity matters (no mocks, no placeholders), a breakpoint check (edge cases, races, partial-commit risk), and a one-line dovetail to the next step.
5. **Cross-step interaction matrix** — a table; each row an interaction between two changes, verified safe (✓) or flagged (⚠ + why).
6. **Findings ranked by severity** — Critical / High / Medium / Low, each with `path:line` and a one-line fix. If everything is Medium, you haven't prioritised.
7. **Final go/no-go** — numbered revisions to fold back into the plan. Concrete, one-line each.

### Things to actively hunt for

- **Field-path assumptions against real data shapes.** New code reads `obj.someField` — find the canonical schema (type / model / writer) and confirm the field lives there, at the right nesting. Dict/optional reads (`obj.get("x")`, `obj?.x`) silently return null on a missing field — the code "works" but emits zero-signal output. The most common silent-degradation bug, and the hardest to catch in review.
- **Override paths in reader/writer patterns.** When a function takes optional overrides to skip a re-fetch, trace what's gated behind the "no override" branch. New inputs are often nested in the wrong scope and silently zero out when a caller passes an override.
- **Naming drift.** Removed features still referenced in copy, old names, deprecated function names.
- **Pattern divergence.** New code that doesn't match the existing convention reads as a bug to the next person.
- **Mock/placeholder data shipping to production.** Anything tagged "TODO replace with real…".
- **Hardcoded constants for things that should be data-driven.** Magic numbers, tier limits, magic strings.
- **Security holes adjacent to the new work.** Client-writable fields that should be server-only, secrets in client bundles, unauthenticated endpoints in the touched area.
- **Frontend gates that don't match backend gates.** Client-side checks without server enforcement, or vice versa.
- **Idempotency / transactional gaps.** Event handlers that double-write on retry; multi-write sequences that aren't atomic and can half-commit.
- **Broken cooldowns / counters.** In-memory timers that don't survive a reload; counters that reset on deploy.
- **Cross-file invariants.** Anything in `.claude/rules/` the new work could violate.
- **Dead code and unused imports** in the touched files.

### How to read efficiently

- Batch parallel reads when files are independent (4–6 per message).
- Skip vendored code (`node_modules`, `.venv`, `dist`, `build`).
- Files >2000 lines: read in chunks via `offset`/`limit`.
- Grep first for cross-references, then Read for context.
- Read foundational files first (config, auth, the central service) — their patterns set the constraints.

### Anti-patterns

- "It looks fine" without quoting a line.
- Generating new mock code in the recon output — recon references existing code, it doesn't write new code.
- Listing every finding at the same severity.
- Ending without a go/no-go and a numbered revision list.

---

## After pre-plan

Do not start writing code. Hand the brief to the **planner** (or the user). The validated revisions get folded into the plan document — never let them live only in chat history. If the change is large, a second recon pass after the first round of revisions often surfaces the cross-step interactions that only become visible once the obvious corrections are applied — offer it.

**Recon before the operation. Plan from the brief, not from assumptions.**
