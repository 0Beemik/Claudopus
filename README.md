# Claudopus 🐙

> Multi-agent engineering for Claude Code. Two models tiered by leverage — **Fable 5** reasons, plans, reviews, and audits; **Opus 4.8** builds and verifies. Effort scales to what's at stake.

**Claudopus is a `.claude/` directory** — a set of agent definitions, skills, commands, and rules that transforms Claude Code from a single assistant into a coordinated engineering team.

No new tools. No new CLIs. No tmux gymnastics. Works inside your existing VS Code + Claude Code setup today.

Claudopus is **community-first and MIT-licensed** — free to use, fork, and reshape. It's just markdown and JSON; every rule is readable and yours to change. Issues and PRs welcome.

> ### ⚠️ Before you run it — two heads-ups
>
> 1. **Fable 5 needs 30-day data retention.** The five Fable-tier agents (orchestrator, planner, interviewer, reviewer, auditor) require a Claude org with **30-day data retention** — they are **not available under zero data retention (ZDR)** and will error there. The Opus 4.8 agents (executor, verifier) work either way. If your org is on ZDR, either enable retention or point the Fable agents at an Opus model in their frontmatter (see [Customising](#customising)).
> 2. **Updating from an older Claudopus?** Re-run `./install.sh` (or re-copy `.claude/`) so you pick up the new **`auditor`** agent and the Fable-tuned prompts. A stale install silently misses the final audit gate.

---

## How it works

You describe what you want. The orchestrator coordinates a team of specialized agents and ships working code.

```
/claudopus add a password reset flow
```

```
orchestrator (Fable 5)
  ├── interviewer  → clarifies scope, eliminates ambiguity           (Fable 5)
  ├── planner      → produces an executable implementation plan      (Fable 5)
  ├── executor ×N  → implements in parallel on isolated branches     (Opus 4.8)
  ├── reviewer     → audits correctness, security, SOLID compliance  (Fable 5)
  ├── verifier     → runs tests, validates, commits clean code       (Opus 4.8)
  └── auditor      → final sign-off: intent, coherence, readiness    (Fable 5)
```

Every agent has a defined role, a specific model, and a clear handoff protocol. The orchestrator reads your project memory and routes work to the right agent at each stage.

---

## Why Claudopus

Claudopus uses **Claude Code's native subagent system** — the orchestration layer Anthropic built. No tmux panes, no filesystem mailboxes, no provider fallback chains, no runtime to install. Just files Claude Code already knows how to read.

- **Native subagents.** The orchestrator spawns the interviewer, planner, executor, reviewer, verifier, and auditor as real Claude Code subagents — each with its own context window and a clear handoff. No orchestration abstraction bolted on top.
- **Two models, tiered by leverage.** **Claude Fable 5** — Anthropic's most capable model — runs the reasoning and judgment core: `effort: max` where the whole run pivots on getting it right (orchestrator, planner, auditor) and `effort: medium` for the focused Fable work (interviewer, reviewer). **Claude Opus 4.8** runs the high-volume build and verify path at `effort: high` (executor, verifier). The premium model sits where correctness compounds; the efficient model carries the throughput.
- **Pre-planning that's real.** Every non-trivial change is *decided* (the `actions` framework — past/present/future) and *reconned* against the actual code at line precision **before** a plan is written. The plan is grounded in the codebase, not assumptions.
- **Discipline baked in.** TDD-first execution, evidence-before-done verification, a deliberate security pass, and git-worktree isolation for parallel work.
- **Just files.** Markdown + JSON. Copy a folder to install; edit markdown to customise. Zero dependencies, nothing to keep running.

---

## Install

### Prerequisites
- [Claude Code](https://claude.ai/code) installed and authenticated
- Node.js (for hooks)
- Git

### Project install

```bash
git clone https://github.com/0Beemik/Claudopus.git
cd claudopus
chmod +x install.sh
./install.sh
```

Installs into `.claude/` in your current working directory.

### Global install

Available in every project, every session:

```bash
./install.sh --global
```

### Manual install

Claudopus is just files. Copy `.claude/` into your project root and you're done.

```bash
cp -r claudopus/.claude /your/project/.claude
```

### Validate

```bash
./install.sh --check
```

---

## Commands

Once installed, these are available inside Claude Code:

| Command | What it does |
|---|---|
| `/claudopus [task]` | Full pipeline — interview → plan → build → review → verify → audit |
| `/plan [task]` | Generate a plan without building yet |
| `/build` | Execute the current plan |
| `/build [task-name]` | Execute one specific task |
| `/review` | Review the current branch diff |
| `/review [path]` | Review a specific file or module |

---

## Agents

| Agent | Model | Role |
|---|---|---|
| `orchestrator` | Fable 5 `effort: max` | Routes tasks, coordinates agents, manages the lifecycle |
| `interviewer` | Fable 5 `effort: medium` | Socratic clarification before any planning |
| `planner` | Fable 5 `effort: max` | Converts requirements into executable specs |
| `executor` | Opus 4.8 `effort: high` | Implements tasks — runs in parallel for independent work |
| `reviewer` | Fable 5 `effort: medium` | Correctness, security, SOLID compliance audit |
| `verifier` | Opus 4.8 `effort: high` | Tests, build validation, final commit |
| `auditor` | Fable 5 `effort: max` | Final sign-off — intent fidelity, whole-system coherence, production readiness |

---

## Project memory

`memory/project.json` persists your project context across sessions.

After installing, fill in your stack and the agents will match your conventions automatically:

```json
{
  "stack": {
    "language": "TypeScript",
    "framework": "Next.js 14",
    "database": "PostgreSQL",
    "styling": "Tailwind CSS",
    "testing": "Vitest"
  },
  "conventions": {
    "naming": "camelCase functions, PascalCase components",
    "imports": "named exports, @/ path alias"
  }
}
```

The orchestrator reads this at the start of every session. Architectural decisions get written back at the end.

---

## File structure

```
.claude/
├── CLAUDE.md                    ← master identity, rules, routing logic
├── settings.json                ← model config, permissions, hooks
│
├── agents/
│   ├── orchestrator.md          ← Fable 5 — coordinates everything
│   ├── interviewer.md           ← Fable 5 — clarifies requirements
│   ├── planner.md               ← Fable 5 — produces implementation specs
│   ├── executor.md              ← Opus 4.8 — parallel implementation worker
│   ├── reviewer.md              ← Fable 5 — code review and security audit
│   ├── verifier.md              ← Opus 4.8 — tests, validation, commit
│   └── auditor.md               ← Fable 5 — final sign-off before ship
│
├── skills/
│   ├── deep-interview.md        ← Socratic clarification process
│   ├── plan.md                  ← spec generation workflow
│   ├── build.md                 ← implementation loop and standards
│   ├── review.md                ← review checklist
│   ├── verify.md                ← test and ship checklist
│   └── commit.md                ← conventional commit format
│
├── commands/
│   ├── claudopus.md                 ← /claudopus
│   ├── plan.md                  ← /plan
│   ├── build.md                 ← /build
│   └── review.md                ← /review
│
├── hooks/
│   └── settings.json            ← SubagentStop, Stop, PreToolUse handlers
│
└── memory/
    ├── project.json             ← persistent project context
    └── plans/                  ← generated plan files (per feature)
```

---

## Customising

### Add project-specific rules

Append to `.claude/CLAUDE.md`:

```markdown
## Project-specific rules

- Never modify files in `src/legacy/` without a migration plan
- All API routes must go through the `withAuth` middleware
- Component props must use the `ComponentProps` convention in `types/`
```

### Add your own agents

Drop a markdown file into `.claude/agents/`:

```markdown
---
name: database-specialist
description: Use this agent for schema changes, migrations, or query optimisation.
model: claude-opus-4-8
effort: high
tools:
  - Read
  - Write
  - Bash
---

You are a database specialist with deep knowledge of [your DB]...
```

Claude Code picks it up automatically. No registration needed.

### Adjust model routing

Every agent's model and effort live in its frontmatter — no code to change. Want the whole team on one model? Change the `model` field across `.claude/agents/*.md`. Prefer a different effort split? Adjust `effort` per agent. The defaults put Fable 5 on the reasoning core and Opus 4.8 on build/verify.

---

## Contributing

Claudopus is intentionally simple. See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

**Good contributions:**
- Better agent prompts — more precise, same structure
- New domain-specific skills (Prisma, GraphQL, Docker, mobile, etc.)
- Bug fixes in the install script
- Documentation and examples

**Not a fit:**
- Support for other AI providers
- External runtime dependencies
- Orchestration abstractions on top of what already works

---

## Philosophy

> The best AI coding system is one you understand completely.

Claudopus is a couple dozen markdown files and a few JSON files. You can read every rule, every prompt, every decision it makes. You can change any of it. Nothing is a black box.

The complexity in other agent harnesses exists because they're building orchestration on top of CLIs that weren't designed for it. Claudopus uses the system Anthropic built. Less infrastructure, more results.

---

## License

MIT — see [LICENSE](LICENSE)

---

## Acknowledgements

Inspired by the ambition of [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent), [oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex), and the broader community pushing Claude Code to its limits. Claudopus is a different bet on the same vision: production-ready code from a coordinated AI team, with the simplest possible foundation underneath.
