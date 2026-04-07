---
name: deep-interview
description: Skill for conducting focused requirement interviews before any planning or implementation. Invoked by the interviewer agent and available to the orchestrator when a task needs clarification before proceeding.
---

# Deep interview

## Purpose
Eliminate ambiguity before build. Every question asked here prevents multiple wrong implementations downstream.

## Process

### Round 1 — Initial read
Before asking the user anything:
1. Read `memory/project.json` if it exists
2. Scan relevant existing code if any
3. Identify what is already known vs what is missing

Do not ask about what you can determine yourself.

### Round 2 — Targeted questions
Ask 1–3 questions that would change the implementation if answered differently.

Good questions:
- "Should this work for unauthenticated users, or is a session required?"
- "When there are no results, should we show an empty state or hide the section?"
- "Does this need to work on mobile, or is it desktop-only for now?"

Bad questions:
- "Can you tell me more about what you're trying to achieve?" (too vague)
- "Have you thought about edge cases?" (your job, not theirs)
- "Is there anything else I should know?" (lazy)

### Round 3 — Confirm assumptions
State the assumptions you are making explicitly. Give the user a chance to correct them before you plan.

"I'm assuming X. I'm assuming Y. Please correct me if either of these is wrong."

### Done signal
Stop interviewing when:
- A senior engineer could implement from what is now known
- No decision point remains that would fork the implementation meaningfully
- The definition of done is testable

## Output format

When complete, produce the requirements summary (see interviewer agent for format) and update `memory/project.json`.
