---
name: actions
description: Unified decision framework for all non-trivial actions. Combines root cause diagnosis (what went wrong) with deliberate decision-making (what should we do). Evaluates every action against past, present, and future before committing. Use before any bug fix, any architectural choice, any significant code change — and as Phase A of the pre-plan skill. Prevents shallow fixes AND reckless forward decisions.
---

# Actions

Every action has consequences across three dimensions: what we've already done, what we're doing now, and what we'll need to do next. This skill forces deliberate evaluation across all three before committing to anything.

This skill is **rigid** — follow every phase in order. Do not skip ahead. Do not implement until Phase 6 grants clearance.

## When to use

- A bug needs fixing (diagnosis mode)
- A feature needs building and there are multiple approaches (decision mode)
- An architectural choice has trade-offs (decision mode)
- Something was "fixed" but the problem persists (diagnosis mode)
- You're about to change shared code, interfaces, or data structures (both modes)
- Any time the right path forward isn't immediately obvious

## Where this fits

`actions` is the **decision/diagnosis methodology** for Claudopus. It is invoked two ways:

1. **As Phase A of `pre-plan`** — when prepping a non-trivial change for the planner, `actions` decides *the right approach* before `recon` audits it against the code.
2. **Standalone, reactively** — a bug surfaces mid-build, or a judgment call appears that isn't tied to planning. Run `actions` on its own; no plan required.

It is the full diagnostic method plus forward-looking deliberation — one skill for all consequential actions.

---

## Phase 1: Observe

**Goal:** Understand the full situation before forming any opinion. Collect facts, not conclusions.

### For bugs (reactive)

1. **State the symptom precisely.** What IS happening vs what SHOULD happen. "Score shows 0" not "it doesn't work."

2. **Trace the full data flow** from origin to display:
   - Where does the UI read the value? (component, field path, prop chain)
   - Where does that data come from? (server state, context, local state, props)
   - Where is that data fetched? (API endpoint, query, cache)
   - Where is that data written? (which function, which trigger, which event)
   - What is the write-to-read timing? (does the write settle before the read?)

3. **At each link in the chain, ask:** "Could this link be broken?" If yes, add it to the candidate list with a one-line hypothesis.

4. **Read the actual code** at every link. Do not guess what a function does — read it. Do not assume a field name — check it. Do not trust that a function is called — find the call site.

### For decisions (proactive)

1. **State the goal precisely.** What must be true when this action is complete?

2. **Map what exists.** What code, data, and flows are already in place that this action touches? Read them.

3. **Identify the decision points.** Where are there multiple valid approaches? List each with a one-line description.

4. **Identify constraints.** What is non-negotiable? (existing API contracts, deployed data schemas, user-facing behaviour that must not change)

### Output format

```
## Situation

[Clear statement of what we're dealing with]

## Candidates / Options

1. [File:line or approach] — description
2. [File:line or approach] — description
3. [File:line or approach] — description
...
```

Minimum 3. If you only found 1, you haven't looked hard enough.

---

## Phase 2: Look Back (Past)

**Goal:** Evaluate each candidate/option against what already exists. Does this contradict, undo, or conflict with decisions already made?

### Questions to answer

For each candidate/option:

- **Does this respect the work already done?** Or does it silently undo a prior decision?
- **Has this been tried before?** Check git history, memory, prior conversation. If it failed before, why would it succeed now?
- **Does this align with established patterns?** Or does it introduce an inconsistency? If breaking a pattern, is that justified?
- **What existing code does this touch?** What assumptions did that code make that we'd be violating?

### For bugs specifically

- **Does this code even execute?** Is it in a dead branch? Is the function actually called?
- **Has this code ever worked?** If yes, what changed? If no, why was it assumed to work?
- **Can I prove this is NOT the cause?** Use evidence, not intuition.

### Output format

```
## Past evaluation

- Candidate 1: [COMPATIBLE / CONFLICTS with past decision X because...]
- Candidate 2: [ELIMINATED — evidence: ...]
- Candidate 3: [COMPATIBLE / was tried before in commit abc123, failed because...]

## Remaining after past check

1. [Description] — compatible because [reason]
3. [Description] — compatible because [reason]
```

---

## Phase 3: Look Around (Present)

**Goal:** Evaluate the remaining options against the current state. Is this the right action right now? Is there a simpler or safer alternative?

### Questions to answer

- **Is this the simplest action that achieves the goal?** If a more complex approach has the same outcome, choose simpler.
- **What are we trading off?** Every action trades something — name it explicitly.
- **Is there a safer alternative?** Could we achieve the same result with less risk to existing functionality?
- **What is the blast radius?** How many files, functions, and flows does this touch? The smaller the better.
- **Are there dependencies or ordering constraints?** Does action A need to complete before B can start?

### For bugs specifically

- **Do the remaining candidates share a common dependency?** Same cache, same query, same state?
- **Is there an ordering dependency?** Could candidate A's failure cause candidate B?
- **Is there a single point of failure?** If fixing ONE thing resolves multiple symptoms, that's the root cause.

### Output format

```
## Present evaluation

- Option 1: [Blast radius: N files] [Trade-off: X for Y] [Simpler alternative exists: yes/no]
- Option 3: [Blast radius: N files] [Trade-off: X for Y]

## Causal chain (bugs only)

[Event] -> [Function A] -> [Write to X] -> [Read from X] -> [Display]
                                ^
                                |
                          BREAK: [description]

## Best current option

[Which option and why it wins on present-state analysis]
```

---

## Phase 4: Look Forward (Future)

**Goal:** Evaluate the chosen approach against what comes next. Does this action open doors or close them? Does it create debt?

### Questions to answer

- **Does this make the next action easier or harder?** Think one and two steps ahead.
- **Does this create technical debt?** If yes, is the debt justified and documented?
- **Does this close off options we might need?** Are we painting ourselves into a corner?
- **Will this still make sense in 3 months?** Or is it a band-aid that future-us will curse?
- **Does this change any public interface or data contract?** If yes, what breaks downstream?
- **Is this a one-way door or a two-way door?** One-way doors (schema changes, published APIs, deleted data) demand more scrutiny than two-way doors (internal refactors, UI changes).

### For bugs specifically

- **Does this fix introduce a new failure mode?** Could the fix itself break under different conditions?
- **Does this fix depend on timing that might not hold?** Race conditions, async ordering, cache staleness.
- **If the fix doesn't work, is the rollback clean?** Can we undo this without side effects?

### Output format

```
## Future evaluation

- Next action enabled: [what this makes possible]
- Next action blocked: [what this makes harder, if anything]
- Debt introduced: [none / description of debt and justification]
- Door type: [one-way / two-way]
- Rollback difficulty: [trivial / moderate / hard — why]

## Future verdict

[PROCEED / PROCEED WITH CAUTION / RECONSIDER — and why]
```

---

## Phase 5: Simulate

**Goal:** Mentally execute the chosen action through the actual code. Verify it achieves the goal without breaking what exists.

### Process

1. **Write the action plan** in plain English. What exactly will you change, in which file, at which line?

2. **Walk through the execution path** with the change applied:
   - Start at the trigger (user action, function call, event)
   - Step through every function, state update, async operation
   - At each step: "With this change, what value does this variable hold NOW?"
   - Continue until you reach the final output

3. **Check for side effects:**
   - Does this break any other code path using the same function/field?
   - Does this introduce a race condition?
   - Does this depend on external state (indexes, env vars, third-party APIs) being in place?

4. **Predict the outcome.** Be specific — not "it will work" but "the metric will show 1/5 because X.filter returns [Y]."

### Output format

```
## Action plan

1. [File:line] — Change [what] to [what]. Reason: [addresses what]
2. [File:line] — Change [what] to [what]. Reason: [why]

## Execution trace

1. [Trigger event]
2. [Function] fires, calls [other function]
3. [Variable] now holds [value] (previously: [old value])
4. [Write/Read] succeeds with [data]
5. UI renders [specific output]

## Side effect check

- [Other path]: NOT affected because [reason]
- [Edge case]: Handled because [reason]

## Prerequisites

- [Any external dependency that must be in place: index deployed, env var set, etc.]
```

---

## Phase 6: Act

**Goal:** Execute with confidence. Only reached after Phase 5 is complete.

### Rules

- Apply ONLY the changes identified in Phase 5. Do not add extras.
- After each file change, verify the build still compiles.
- After all changes, trace the execution path one more time against the actual code to confirm.
- **If the action doesn't produce the predicted outcome, return to Phase 1.** Do not stack more changes on top.

### Post-action check

After implementation, answer:

- Did the outcome match the Phase 5 prediction? If not, what differed?
- Did any side effect from Phase 5 actually occur?
- Does `memory/project.json` need updating to record this decision for future sessions?

---

## Quick reference

```
Phase 1: OBSERVE      — What's the full situation? (minimum 3 candidates/options)
Phase 2: LOOK BACK    — Does this respect the past? (evidence-based elimination)
Phase 3: LOOK AROUND  — Is this the best action now? (simplest, safest, smallest blast radius)
Phase 4: LOOK FORWARD — What does this enable or prevent? (one-way vs two-way doors)
Phase 5: SIMULATE     — Walk through it mentally (predict the exact outcome)
Phase 6: ACT          — Execute with confidence (build, verify, done)
```

Never skip to Phase 6. The cost of phases 1-5 is minutes. The cost of skipping them is hours of wrong fixes and architectural regret.

**Our actions define us. Act deliberately.**
