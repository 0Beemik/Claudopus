# Omnipus tool map

> Snapshot of https://code.claude.com/docs/en/tools-reference — last synced
> 2026-07-12. Reconciled by the orchestrator on `SYNC_PENDING` (see SYNC.md).
> "Prompts" = whether the tool prompts for permission in the default mode for
> paths inside the working directory.

Tool names are the exact strings used in permission rules, subagent `tools:`
frontmatter, and hook matchers. Knowing which tool prompts tells Omnipus where
an absolute-permission stop is expected versus where it can proceed freely.

## Core tools by role in the pipeline

| Tool | Prompts | Where Omnipus uses it |
|---|---|---|
| `Agent` | No | Every fleet gate — spawn planner/executor/reviewer/verifier/auditor by `subagent_type` |
| `Task*` (`TaskCreate/Get/List/Update/Output/Stop`) | No | Track a multi-phase run; drive background tasks |
| `Read` / `Glob` / `Grep` | No* | Orient, recon (*prompts for paths outside working dir) |
| `Edit` / `Write` / `NotebookEdit` | Yes | BUILD / RECONCILE edits (executor) |
| `Bash` | Yes | Run/build/test (read-only builtins don't prompt) |
| `LSP` | No | Definitions, references, type errors during review |
| `Monitor` | Yes | Watch logs / CI / polled status during long builds |
| `EnterWorktree` / `ExitWorktree` | No | Opt-in real parallelism — isolated worktree per executor |
| `WebFetch` / `WebSearch` | Yes | Research in pre-plan; doc self-sync |
| `Skill` | Yes | Invoke Tier-1 slash commands / bundled skills |
| `Workflow` | Yes | Dynamic workflows that fan work across subagents (e.g. `/batch`) |
| `Artifact` | Yes | DELIVER — publish an HTML/Markdown deliverable |
| `PushNotification` / `SendUserFile` | No / No | Opt-in escalation reach on long/unattended runs |
| `CronCreate/Delete/List`, `RemoteTrigger`, `ScheduleWakeup` | No | Repeatable work: `/schedule`, self-paced `/loop` |
| `SendMessage` | No | Resume a spawned subagent with its context intact |
| `ReportFindings` | No | Structured code-review output |
| `AskUserQuestion` | No | The few build-deciding questions (understanding gate) |
| `EnterPlanMode` / `ExitPlanMode` | No / Yes | `/plan`; present a plan for approval |

## Permission posture (auto-mode safety)

- `deny` in `settings.json` is the hard floor; the `bash-safety` hook blocks
  destructive commands even under `acceptEdits`.
- The tools that **prompt** (`Edit`, `Write`, `Bash`, `WebFetch`, `Artifact`,
  `Monitor`, `Workflow`) are exactly where an absolute-permission stop is
  expected. Omnipus proceeds freely on no-prompt tools once understanding is
  locked, and stops for the destructive/irreversible subset per the SKILL.
- MCP servers add tools beyond this list; discover with `/mcp`. Disabling a tool
  = add its name to `deny`.
