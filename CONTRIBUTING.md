# Contributing to Claudopus

Thanks for your interest in contributing. Claudopus has a simple goal: be the most capable Claude Code agent system with the smallest possible footprint. Every contribution is evaluated against that goal.

---

## The core constraint

Claudopus must remain understandable by reading it. If a contributor can't understand what every file does in 30 minutes, the project has failed its mission. Complexity is a cost, not a feature.

---

## What we welcome

### Better agent prompts
The agent markdown files are the heart of the system. If you've found that rephrasing a rule, reordering a section, or adding a constraint produces meaningfully better results — open a PR with the change and a description of what improved and why.

Good prompt PRs include:
- Before/after description of the behaviour change
- The specific scenario that motivated the change
- Why the new wording is more precise

### New domain skills
Skills in `.claude/skills/` encode workflow knowledge for specific domains. The existing set covers the general case. Domain-specific skills are a great fit:

- `prisma.md` — schema design, migration patterns, query optimisation
- `graphql.md` — resolver patterns, N+1 prevention, schema conventions  
- `docker.md` — Dockerfile patterns, compose conventions, layer optimisation
- `mobile-react-native.md` — platform-specific patterns, navigation, permissions
- `accessibility.md` — WCAG checklist, ARIA patterns, focus management

Skills follow the same format as the existing ones: YAML frontmatter + markdown instructions. They should be narrow, specific, and immediately useful — not a generic overview.

### Install script improvements
The `install.sh` bash script is functional but not exhaustive. Improvements to:
- Windows / PowerShell support
- Error messages and recovery guidance
- Edge cases in merge mode

### Documentation
Clear examples of real tasks run through Claudopus, annotated transcripts showing the agent handoff sequence, or corrections to anything inaccurate in the existing docs.

---

## What doesn't fit

**Other AI providers.** Claudopus is Anthropic-native by design. The simplicity comes from targeting one API with two models. Adding fallback chains for other providers is exactly the complexity we're avoiding.

**External runtime dependencies.** No npm packages, no Python libraries, no compiled binaries in the repo. Hooks use inline Node.js one-liners for a reason — they work on any machine with Node installed, with no install step.

**Orchestration abstractions.** If you want to add a TypeScript runtime, a message queue, or a state machine on top of Claude Code's native subagent system — that's a different project. Claudopus is intentionally a layer of files, not a framework.

**Expanding agent count significantly.** Six agents cover the full lifecycle. New agents need a compelling case that they handle something genuinely distinct that no existing agent should handle.

---

## How to contribute

1. **Open an issue first** for anything beyond a small fix. Describe what you want to change and why. This saves everyone time if the direction isn't a fit.

2. **Fork and branch.** Use `feature/description` or `fix/description`.

3. **Keep the diff small.** One concern per PR. A PR that improves the executor prompt and adds a new skill and fixes the install script is three PRs.

4. **Test it.** Run the thing you changed against a real project in Claude Code. Describe what you tested in the PR description.

5. **No AI-generated PRs without disclosure.** If you used Claudopus or another AI to generate the contribution, say so. We're not opposed to it — we just want to know.

---

## Reporting issues

Open an issue with:
- What you expected to happen
- What actually happened
- The task you gave Claude Code
- Which agent was active when it went wrong (check the agent log at `~/.claude/claudopus-agent-log.jsonl`)

Vague reports like "it didn't work" can't be acted on.

---

## Code of conduct

Be direct, be constructive, be respectful. Disagreements about technical direction are fine — personal attacks are not. We're all here to make this better.
