---
name: commit
description: Skill for writing correct git commits following conventional commit format. Used by the verifier agent and available to executors.
---

# Commit

## Format

```
type(scope): short description (max 72 chars)

Optional body — explain WHY, not what. What is visible in the diff.
Why is not. Two to four sentences max.

Optional footer — "Closes #123", "Breaking change: ...", "Co-authored-by: ..."
```

## Types

| Type | When to use |
|---|---|
| `feat` | New feature or behaviour |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or correcting tests |
| `chore` | Build, config, dependency changes |
| `docs` | Documentation only |
| `perf` | Performance improvement |
| `ci` | CI/CD pipeline changes |

## Scope

The scope is the area of the codebase affected — module name, component name, or layer. Keep it short.

Examples: `auth`, `api`, `dashboard`, `db`, `types`, `hooks`

## Rules

- Present tense, imperative mood: "add", not "added" or "adds"
- No period at the end of the subject line
- Subject line is a command: "fix null check in user resolver" — reads as "if applied, this commit will fix null check in user resolver"
- Body explains motivation and context — not a list of files changed
- Never commit broken code
- Never commit with `git add .` — stage intentionally

## Examples

Good:
```
feat(auth): add JWT refresh token rotation

Refresh tokens now rotate on use to limit exposure window.
Previous token is invalidated immediately on refresh.
Closes #247
```

Good:
```
fix(api): handle null user in session resolver

getUserFromSession returned null for expired sessions
but the resolver expected it to throw. Add explicit null
check and return 401 response.
```

Bad:
```
fix stuff
```

Bad:
```
Updated auth.ts and user.ts and fixed some bugs and added tests
```

## Staging discipline

Stage only what belongs in this commit:
```bash
git add src/auth/refresh.ts
git add src/auth/refresh.test.ts
git add src/api/session.ts
```

Never:
```bash
git add .
git add -A
```

If you have unrelated changes, commit them separately with their own message.
