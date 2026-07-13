# Omnipus self-sync protocol

Omnipus's `commands.md` and `tools.md` are snapshots of Anthropic's live docs.
They drift as Claude Code ships new commands and tools. This protocol keeps them
current with **zero manual maintenance**, split across the two things that can
each do their half of the job:

- **Bash (`install.sh`) detects and fetches** — reliable, dumb, always works.
- **The model (orchestrator) reconciles** — the only thing that can read prose
  docs and edit the maps with judgment.

A pure-bash "update the maps from the docs" is impossible: interpreting English
docs into markdown maps needs an LLM. So bash never edits the maps — it only
decides *when* an update is due and stages the fresh source.

## The manifest — `version.json`

```json
{
  "created":          "2026-07-12",   // provenance; never changes
  "docs_last_synced": "2026-07-12",   // resets on each successful reconcile
  "sync_interval_days": 60,           // staleness threshold
  "doc_sources": {
    "commands": "https://code.claude.com/docs/en/commands",
    "tools":    "https://code.claude.com/docs/en/tools-reference"
  }
}
```

Staleness is measured from **`docs_last_synced`, not `created`** — so each
successful sync resets the 60-day clock. (Measuring from `created` would make it
permanently stale one day past the interval and re-fetch on every install.)

## Step 1 — `install.sh` detects (bash)

On every install:
1. Read `docs_last_synced` and `sync_interval_days` from `version.json`.
2. Compute `age = today - docs_last_synced` in days.
3. If `age >= sync_interval_days`:
   - `curl` each `doc_sources` URL into `references/_incoming/` (e.g.
     `commands.remote.md`, `tools.remote.md`).
   - If a fetch **succeeds**, write `references/SYNC_PENDING` with the date.
   - If a fetch **fails** (offline, or the docs 404 in some future year), leave
     the last good snapshot untouched, print a warning, and continue. The only
     failure mode is the docs ceasing to exist — and even then Omnipus keeps
     working on the last snapshot.

## Step 2 — the orchestrator reconciles (model)

On `/omnipus` startup, if `references/SYNC_PENDING` exists:
1. Read the incoming snapshots in `references/_incoming/`.
2. Diff against the current `commands.md` (Tier-1/Tier-2 split) and `tools.md`.
3. Apply the drift: new commands slotted into the right tier and phase; renamed
   or removed tools updated; changed permission defaults corrected.
4. Stamp `docs_last_synced` to today in `version.json`, delete `SYNC_PENDING`
   and the `_incoming/` snapshots.
5. Note in the run's DELIVER that a doc-sync happened and what changed.

New commands default to **Tier 2 (recommend-only)** until classified — a command
is Tier 1 only if the docs mark it a Skill/Workflow or it is a prompt handed to
Claude. When unsure, leave it Tier 2; over-claiming invokability is the exact
failure this project was built to end.

## Optional — always-on sync via a routine

Install-time is the default trigger, but a user who wants currency without
re-running `install.sh` can schedule a cloud routine (`/schedule`, needs
Pro/Max) that runs this same check on a cron and opens a PR with the reconciled
maps. Off by default — it needs a paid plan and network egress.
