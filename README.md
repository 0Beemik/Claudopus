# Claudopus 🐙

> Multi-agent engineering for Claude Code. Opus 4.6 thinks. Sonnet 4.6 builds.

**Claudopus is a `.claude/` directory** — a set of agent definitions, skills, commands, and rules that transforms Claude Code from a single assistant into a coordinated engineering team.

No new tools. No new CLIs. No tmux gymnastics. Works inside your existing VS Code + Claude Code setup today.

---

## How it works

You describe what you want. The orchestrator coordinates a team of specialized agents and ships working code.

```
/start add a password reset flow
```

```
orchestrator (Opus 4.6)
  ├── interviewer  → clarifies scope, eliminates ambiguity
  ├── planner      → produces an executable implementation plan
  ├── executor ×N  → implements in parallel on isolated branches  (Sonnet 4.6)
  ├── reviewer     → audits correctness, security, SOLID compliance
  └── verifier     → runs tests, validates, commits clean code     (Sonnet 4.6)
```

Every agent has a defined role, a specific model, and a clear handoff protocol. The orchestrator reads your project memory and routes work to the right agent at each stage.

---

## Why Claudopus

Projects like [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) and [oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex) do impressive work — but they bolt orchestration on top of CLIs that weren't designed for it. The result is tmux pane coordination, stale state recovery, fallback chains across 10+ model providers, and hundreds of files of infrastructure just to run parallel agents.

Claudopus uses **Claude Code's native subagent system** — the orchestration layer Anthropic built. Less engineering, better results.

| | oh-my-openagent | Claudopus |
|---|---|---|
| Underlying executor | OpenCode / Claude Code CLI | Claude Code native subagents |
| Model support | 10+ providers, fallback chains | Opus 4.6 + Sonnet 4.6 |
| Setup | npm install + configure | copy a folder |
| Total files | 95+ utility files | 14 markdown + 2 JSON |
| State coordination | tmux panes + filesystem mailboxes | Claude Code handles it |
| Customisation | TypeScript config schemas | edit markdown files |

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
| `/start [task]` | Full pipeline — interview → plan → build → review → verify |
| `/plan [task]` | Generate a plan without building yet |
| `/build` | Execute the current plan |
| `/build [task-name]` | Execute one specific task |
| `/review` | Review the current branch diff |
| `/review [path]` | Review a specific file or module |

---

## Agents

| Agent | Model | Role |
|---|---|---|
| `orchestrator` | Opus 4.6 `effort: max` | Routes tasks, coordinates agents, manages the lifecycle |
| `interviewer` | Opus 4.6 `effort: max` | Socratic clarification before any planning |
| `planner` | Opus 4.6 `effort: max` | Converts requirements into executable specs |
| `executor` | Sonnet 4.6 `effort: high` | Implements tasks — runs in parallel for independent work |
| `reviewer` | Opus 4.6 `effort: max` | Correctness, security, SOLID compliance audit |
| `verifier` | Sonnet 4.6 `effort: high` | Tests, build validation, final commit |

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
│   ├── orchestrator.md          ← Opus 4.6 — coordinates everything
│   ├── interviewer.md           ← Opus 4.6 — clarifies requirements
│   ├── planner.md               ← Opus 4.6 — produces implementation specs
│   ├── executor.md              ← Sonnet 4.6 — parallel implementation worker
│   ├── reviewer.md              ← Opus 4.6 — code review and security audit
│   └── verifier.md              ← Sonnet 4.6 — tests, validation, commit
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
│   ├── start.md                 ← /start
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
model: claude-opus-4-6
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

Want everything on Opus? Change the `model` field in `executor.md` and `verifier.md`. All decisions are in the frontmatter — no code to change.

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

Claudopus is 14 markdown files and two JSON files. You can read every rule, every prompt, every decision it makes. You can change any of it. Nothing is a black box.

The complexity in other agent harnesses exists because they're building orchestration on top of CLIs that weren't designed for it. Claudopus uses the system Anthropic built. Less infrastructure, more results.

---

## License

MIT — see [LICENSE](LICENSE)

---

## Acknowledgements

Inspired by the ambition of [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent), [oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex), and the broader community pushing Claude Code to its limits. Claudopus is a different bet on the same vision: production-ready code from a coordinated AI team, with the simplest possible foundation underneath.
