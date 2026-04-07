---
name: build
description: Skill for implementing code from a defined plan. Covers the implementation loop, code standards, and completion criteria. Used by the executor agent.
---

# Build

## Implementation loop

```
read task → read all relevant files → implement → test → fix if failing → report
```

Never break this loop. Never skip the read phase. Never report done before testing.

## Read phase (non-negotiable)

Before writing any code:
1. Read the specific task from the plan file
2. Read every file you will touch
3. Read files that import from or are imported by files you will touch
4. Read the relevant tests
5. Read `memory/project.json` for conventions

Time spent reading saves time spent rewriting.

## Implement phase

### File creation
Only create files specified in the plan. If you identify a file that should exist but is not in the plan, note it and create it — but flag the deviation in your report.

### File modification
Make the minimum change that accomplishes the task. If a larger refactor would help but is not in scope, flag it as a follow-up — do not do it now.

### Function writing
- One function, one responsibility
- Explicit parameter and return types (TypeScript/Python)
- Handle errors — do not let exceptions surface unhandled
- Document non-obvious logic with inline comments — not everything, just what is not clear from reading

### No shortcuts
- No `any` in TypeScript without justification
- No bare `except` in Python
- No swallowed errors (`catch(e) {}`)
- No commented-out code left in files
- No console.log / print debug statements

## Test phase

Run tests after implementation. Do not skip this step.

If tests fail:
1. Read the failure message in full
2. Trace to the specific line causing it
3. Fix the specific cause — do not shotgun-patch
4. Run again
5. If still failing after one targeted fix, stop and report rather than iterating blindly

## Completion criteria

You are done when:
- The task from the plan is fully implemented (no stubs, no placeholders)
- All tests pass
- Type checking passes
- No lint errors introduced
- The implementation matches the plan (or deviations are documented)

## Common traps to avoid

- **Scope creep**: Noticed something else to fix? Flag it, do not fix it.
- **Gold plating**: Adding more than the task requires. The plan is the scope.
- **Assumption coding**: Not sure how something works? Read more code. Still not sure? Ask.
- **Test skipping**: "Tests will probably pass." Run them.
- **Silent workarounds**: Found a weird behaviour and worked around it? Document it.
