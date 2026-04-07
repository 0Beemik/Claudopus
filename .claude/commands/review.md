# Review

Run the reviewer agent on the current branch diff or a specified file/module. Use this for standalone code reviews, pre-merge audits, or security checks.

## What happens

1. The reviewer reads the diff (or specified files)
2. Checks correctness, security, SOLID compliance, conventions, and test quality
3. Produces a structured report with blockers and advisory items
4. Issues a verdict: APPROVED, CHANGES REQUIRED, or BLOCKED

## Usage

```
/review
/review src/auth/
/review the user model
/review for security issues only
```

With no argument, reviews the current branch diff against main.
With a path, reviews that specific file or directory.
With a focus area, narrows the review to that concern.

## Verdict meanings

**APPROVED** — ready for verifier to run tests and merge

**CHANGES REQUIRED** — specific blockers listed must be resolved, then re-review runs automatically

**BLOCKED** — fundamental issue requiring replanning; escalated to you with explanation

## Using review standalone

You do not need to be in a full Claudopus workflow to use `/review`. It works on any code — including code written manually or imported from elsewhere.

Useful for:
- Reviewing a PR before merging
- Auditing an existing module for security issues
- Checking a new dependency's integration
- Pre-commit review of your own changes
