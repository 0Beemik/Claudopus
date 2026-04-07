# Build

Execute the current plan from `memory/project.json`. Use this after `/plan` has been run and reviewed, or when a plan already exists in project memory.

## What happens

1. The orchestrator reads the current plan from `memory/project.json`
2. Spawns executor agents for each task (parallel where tasks are independent)
3. Executors work on separate branches
4. When complete, the reviewer is invoked automatically
5. If review passes, the verifier runs tests and ships

## Usage

```
/build
/build task-1
/build auth-module
```

With no argument, runs all tasks in the current plan.
With a task name or module, runs only that specific task.

## Prerequisites

A plan must exist in `memory/project.json` under `current_task`.
If no plan exists, run `/plan` first.

## Parallel execution

Independent tasks run in parallel automatically. The orchestrator identifies which tasks have no dependencies and spawns executor agents simultaneously. You will see multiple agents working at once.

## If the build fails

The orchestrator surfaces the failure with:
- Which task failed
- What the error was
- Whether it can be auto-retried or needs human input

You do not need to restart from scratch — the orchestrator resumes from the failure point.
