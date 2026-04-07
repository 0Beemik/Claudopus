# Start

Begin a new task with Claudopus. Triggers the full workflow: interview → plan → build → review → verify → ship.

Use this when you have a new feature, fix, or task and want the full pipeline.

## What happens

1. The orchestrator reads your task and existing project memory
2. If requirements need clarification, the interviewer agent runs first
3. Once requirements are clear, the planner produces an implementation plan
4. Executor agents implement the plan (in parallel where possible)
5. The reviewer audits the output
6. The verifier runs tests and ships

## Usage

```
/start build a user profile page with avatar upload
/start add rate limiting to the API
/start fix the login redirect bug
```

## Provide as much context as you have

The more you give, the less time the interview phase takes. You can include:
- What it should do
- Who uses it
- What it connects to
- Any constraints or preferences
- What done looks like to you

The orchestrator will use everything you provide and only ask what is genuinely missing.
