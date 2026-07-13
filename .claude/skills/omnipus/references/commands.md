# Omnipus command map — Tier 1 (invokable) vs Tier 2 (recommend-only)

> Snapshot of https://code.claude.com/docs/en/commands — last synced 2026-07-12.
> The orchestrator reconciles this against the live docs on `SYNC_PENDING`
> (see SYNC.md). Never invoke a command not present in the current session —
> confirm with `/skills` and the live command list.

The split is mechanical, not preference. **Tier 1** commands are prompts or
subagent-orchestrations handed to Claude, so the orchestrator can fire them
mid-task. **Tier 2** commands change the user's account, session, or harness
state, or need a UI — the model can *recommend* them (or suggest `! <command>`),
but cannot press the button.

## Tier 1 — Omnipus invokes these itself, wired by phase

| Phase | Commands |
|---|---|
| PRE-PLAN / research | `/deep-research`, `/claude-api`, `/plan` (enter plan mode) |
| BUILD | `/run`, `/batch` (large parallel change), `/init`, `/run-skill-generator` |
| VERIFY | `/verify`, `/run` |
| REVIEW | `/code-review`, `/security-review`, `/review` (GitHub PR) |
| RECONCILE | `/simplify`, `/code-review --fix` |
| DELIVER | `/dataviz` (+ `Artifact` tool) |
| Repeatable / long-running | `/loop`, `/schedule`, `/autofix-pr`, `/goal`, `/background`, `/fork` |
| Discovery / hygiene | `/skills`, `/context`, `/compact`, `/recap`, `/insights` |

Notes:
- Skill-chaining is available: `/omnipus /code-review …` loads up to six skills
  and passes trailing text as args. Use it where a phase naturally chains.
- `/fork` spawns a subagent that inherits the full conversation — useful for a
  parallel line of work that needs this run's context (unlike a fresh `Agent`).

## Tier 2 — Omnipus recommends, the user runs

Account / auth: `/login`, `/logout`, `/passes`, `/privacy-settings`.
Model / effort / config: `/model`, `/effort`, `/fast`, `/config`, `/permissions`,
`/fewer-permission-prompts`, `/sandbox`, `/hooks`, `/keybindings`, `/statusline`,
`/status`, `/color`, `/scroll-speed`.
Session / context lifecycle (user-facing): `/clear`, `/rewind`, `/resume`,
`/rename`, `/branch`, `/export`, `/copy`, `/compact` *(model may self-trigger for
hygiene)*, `/cd`, `/add-dir`, `/exit`.
Integrations / environment: `/mcp`, `/ide`, `/chrome`, `/install-github-app`,
`/install-slack-app`, `/remote-control`, `/remote-env`, `/desktop`, `/mobile`,
`/setup-bedrock`, `/setup-vertex`, `/plugin`, `/reload-plugins`, `/reload-skills`.
Info / misc: `/help`, `/doctor`, `/debug`, `/cost` (`/usage`), `/stats`,
`/release-notes`, `/feedback`, `/powerup`, `/radio`, `/stickers`, `/heapdump`,
`/advisor`, `/focus`, `/memory`, `/agents`, `/goal` *(Tier 1 above)*.

When a Tier 2 command would help (e.g. "switch to Opus for this build"), say so
explicitly and tell the user how to run it — do not claim to have done it.
