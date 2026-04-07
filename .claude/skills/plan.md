---
name: plan
description: Skill for converting requirements into executable implementation plans. Produces a structured plan file and updates project memory. Used by the planner agent.
---

# Plan

## Purpose
Produce a precise, complete implementation plan that executors can work from without asking follow-up questions.

## Process

### 1 — Codebase read
Read all files in the feature area. Understand:
- What already exists that this builds on
- What patterns are in use (naming, structure, error handling)
- What tests exist and what they expect
- What the entry points are

### 2 — Architecture decision
Decide:
- What new files are needed (and where)
- What existing files change (and what specifically changes)
- How the new code integrates with existing code
- What the data flow is

Apply SOLID principles to every decision. Document reasoning for non-obvious choices.

### 3 — Task decomposition
Break the implementation into discrete tasks:
- Each task is a single coherent unit of work
- Each task has a clear input, output, and test
- Mark dependencies between tasks explicitly
- Mark which tasks can run in parallel

### 4 — Risk identification
Flag anything that could:
- Break existing functionality
- Require a runtime decision the plan does not resolve
- Introduce a new dependency
- Require a migration (data, schema, API)

### 5 — Write the plan
Write to `memory/plans/[feature-name].md` using the plan structure in the planner agent definition.

### 6 — Update memory
Update `memory/project.json`:
```json
{
  "current_task": {
    "name": "[feature name]",
    "plan": "memory/plans/[feature-name].md",
    "tasks": ["task-1", "task-2"],
    "independent_tasks": ["task-1", "task-2"],
    "status": "planned"
  }
}
```

## Quality check before handing off
- Can every task be implemented without asking a follow-up question?
- Is there a testable definition of done for each task?
- Are all dependencies between tasks explicit?
- Are all assumptions documented?

If no to any of these — fix the plan before passing it to the executor.
