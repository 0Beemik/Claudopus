---
name: review
description: Skill for conducting thorough code reviews. Covers correctness, security, SOLID compliance, conventions, and test quality. Used by the reviewer agent.
---

# Review

## Review mindset

You are reading code that will run in production. Your job is to catch what the executor missed, not to rewrite what they built. Be specific. Be fair. Be thorough.

Blockers prevent merge. Advisory items are recorded as follow-up work. Both matter.

## Checklist

### Correctness
- [ ] Implements what the plan specifies — not more, not less
- [ ] All code paths are handled (null checks, empty arrays, error states)
- [ ] Async code is awaited correctly — no floating promises
- [ ] No off-by-one errors in loops or array access
- [ ] Conditional logic is correct — check for accidental truthiness issues
- [ ] Data transformations are correct — types match across boundaries

### SOLID
- [ ] Each class/module/function has one clear reason to change
- [ ] New code extends existing interfaces rather than modifying them
- [ ] Any new subtypes are valid substitutes for their supertypes
- [ ] Interfaces are specific to their consumers — no unused methods
- [ ] Code depends on abstractions, not on concrete implementations

### Security
- [ ] User input is validated at the boundary before use
- [ ] SQL queries use parameterisation — no string concatenation
- [ ] No secrets, tokens, or credentials in code
- [ ] Auth checks are present on all protected operations
- [ ] File paths are sanitised where user input affects them
- [ ] Nothing sensitive is logged

### Performance
- [ ] No N+1 patterns (queries inside loops)
- [ ] No unnecessary full-table scans
- [ ] No large in-memory collections where streaming would serve
- [ ] Caching used correctly where it exists

### Conventions
- [ ] Naming matches the codebase conventions
- [ ] Files are in the correct directories
- [ ] Import style matches (named/default, path aliases)
- [ ] Error handling matches existing patterns

### Tests
- [ ] New behaviours have test coverage
- [ ] Edge cases are tested
- [ ] Tests assert behaviour, not implementation details
- [ ] No tests that always pass regardless of implementation

## Severity classification

**Blocker** — must be fixed before merge:
- Correctness issues that produce wrong output
- Any security vulnerability
- SOLID violations that create maintenance debt with immediate impact
- Missing tests for critical paths

**Advisory** — should be addressed, track as tech debt:
- Performance concerns that are not currently causing problems
- Style inconsistencies that do not affect correctness
- SOLID violations that are acceptable for now with a plan to address
- Test coverage gaps on non-critical paths

## Writing feedback

Be specific. Not "this could be improved" — "line 47 in `auth.ts`: the `userId` parameter is not validated before use in the database query. If a user provides a non-integer ID, this will produce a database error rather than a 400 response. Add `zod.number().int().positive()` validation at the route handler boundary."

The executor receiving this feedback should not have to guess what to change.
