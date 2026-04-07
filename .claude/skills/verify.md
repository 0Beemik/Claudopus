---
name: verify
description: Skill for final validation before shipping. Covers test execution, build validation, and definition-of-done verification. Used by the verifier agent.
---

# Verify

## The standard

Nothing ships without passing every check. This is not a suggestion.

## Checks in order

### 1. Environment check
```bash
git status                    # confirm branch, no unexpected changes
git log --oneline -3          # confirm commit history is clean
```

### 2. Type checking
```bash
# TypeScript
npx tsc --noEmit

# Python
python -m mypy . --ignore-missing-imports
```
Required: zero errors. Type warnings that cannot be resolved without upstream changes should be documented.

### 3. Linting
```bash
# JavaScript/TypeScript
npx eslint . --ext .ts,.tsx,.js,.jsx --fix

# Python (ruff preferred)
python -m ruff check . --fix
```
Auto-fixable issues: fix and commit separately. Non-auto-fixable issues: evaluate. If trivial, fix. If requiring judgment, flag.

### 4. Test suite
```bash
# Full test suite
npm test -- --coverage

# Python
pytest --tb=short --cov=. -q
```

All tests must pass. Coverage must not regress below the baseline in `memory/project.json`.

If a test is failing that predates this change: document it explicitly, do not suppress it, flag it as a pre-existing issue.

### 5. Build
```bash
npm run build
# or production equivalent
```

Build must complete without errors.

### 6. Definition of done
Check every item in the plan's definition of done. Mark each one. If any item is incomplete, stop — do not ship with incomplete items unchecked.

## Trivial fixes allowed

The verifier may fix:
- Import sort order
- Missing semicolons
- Trailing whitespace
- Lint auto-fixes

The verifier may NOT fix:
- Logic errors
- Missing features
- Failing tests (beyond re-running after a trivial fix)
- Anything requiring judgment about what the code should do

Those go back to the executor.

## Worktree merge protocol (parallel builds)

When multiple executors ran on separate branches:
```bash
git checkout -b integration/[feature]
git merge executor/task-1 --no-ff
git merge executor/task-2 --no-ff
# Resolve conflicts — read both sides, compose the correct merge
# If conflict requires judgment about logic: escalate
```

After merge, re-run all checks on the integration branch.

## Ship

When all checks pass:
```bash
git add [files changed in this session]
git commit -m "type(scope): description

Body explaining what changed and why.
Closes #[issue] if applicable."
```

Report: all checks passed, commit hash, branch ready to merge.
