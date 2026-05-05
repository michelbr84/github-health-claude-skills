# github-health-claude-skills

A modular **Claude Skills** repository for auditing the full health of any GitHub project.

You give Claude a GitHub repository URL and (optionally) a scope. Claude inspects the repository, separates verified facts from assumptions, produces a structured health report, and recommends next actions — without ever performing destructive operations on your behalf.

This is the **V1 release**. Skills, references, templates, examples, and evaluation prompts are entirely Markdown. A small `install.sh` is provided for personal installation; it does not perform audits or modify GitHub state.

---

## Quick Start

### Fast install

```bash
curl -fsSL https://raw.githubusercontent.com/michelbr84/github-health-claude-skills/main/install.sh | bash
```

### Install from a cloned copy

```bash
git clone https://github.com/michelbr84/github-health-claude-skills.git
cd github-health-claude-skills
bash install.sh
```

Both methods install 16 skills under `~/.claude/skills/`. The installer creates the directory if needed, backs up any existing skill of the same name with a timestamped suffix, and verifies that every installed skill has a `SKILL.md`. It does not require sudo, does not modify shell profiles, and does not install global dependencies.

Once installed, try a first audit in Claude Code:

```
/github-health quick https://github.com/michelbr84/fluxswap-dex
/github-health actions https://github.com/michelbr84/fluxswap-dex
```

If Claude Code was already running when you installed and `~/.claude/skills/` did not exist before, restart Claude Code so the new skill directory is picked up.

---

## What this repository is

This repository is a curated set of Claude Skills that turn Claude into a disciplined GitHub project auditor. Each skill is a folder containing a `SKILL.md` with YAML frontmatter, clear triggers, an audit procedure, evidence requirements, red flags, an output contract, and safety rules.

The repository contains:

- One **main orchestrator skill** (`github-health/`) that routes a request to the right specialized skill.
- A library of **specialized skills** (`skills/`) for narrow audits: Actions, branches, pulls, issues, security, code scanning, Dependabot, secret scanning, dependency graph, docs, releases, permissions, Linear, cleanup planning, and full audits.
- **Agent profiles** (`agents/`) describing reusable auditor personas with role, focus areas, red flags, and escalation criteria.
- **Templates** (`templates/`) ready to copy into a real audit report.
- **Examples** (`examples/`) showing realistic illustrative outputs.
- **Evaluation prompts** (`evals/`) used to verify the skills behave correctly.

---

## What Claude Skills are

A Claude Skill is a folder named after the skill, containing a `SKILL.md` file. The `SKILL.md` opens with YAML frontmatter (`name` and `description`) followed by Markdown instructions Claude reads when the skill triggers. Each skill in this repo follows the same anatomy:

1. YAML frontmatter (`name`, `description`).
2. Trigger / use cases.
3. Required inputs.
4. Step-by-step audit procedure.
5. Evidence to collect.
6. Red flags.
7. Output format.
8. Safety rules.
9. When to escalate to the main full audit.
10. What not to do.

Specialized skills delegate cross-cutting policies (scoring, severity, output contract, safety) to shared reference files under `github-health/references/` so the SKILL.md files stay focused.

---

## How to use `/github-health`

Invoke the main skill with a repository URL. Optionally prefix with a mode:

```
/github-health <repo>
/github-health quick <repo>
/github-health standard <repo>
/github-health deep <repo>
/github-health actions <repo>
/github-health branches <repo>
/github-health pulls <repo>
/github-health issues <repo>
/github-health security <repo>
/github-health code-scanning <repo>
/github-health dependabot <repo>
/github-health secret-scanning <repo>
/github-health dependency-graph <repo>
/github-health docs <repo>
/github-health releases <repo>
/github-health permissions <repo>
/github-health linear <repo>
/github-health cleanup-plan <repo>
/github-health pre-merge <repo>
/github-health post-merge <repo>
/github-health release-readiness <repo>
```

If no mode is provided, the orchestrator runs the **full** audit.

### Example commands

```
# Full audit
/github-health https://github.com/michelbr84/fluxswap-dex

# Quick audit (top-level signal only)
/github-health quick https://github.com/michelbr84/fluxswap-dex

# Actions-only audit
/github-health actions https://github.com/michelbr84/fluxswap-dex

# Security-only audit
/github-health security https://github.com/michelbr84/fluxswap-dex

# Branch cleanup plan (approval-gated)
/github-health cleanup-plan https://github.com/michelbr84/fluxswap-dex

# Linear synchronization audit
/github-health linear https://github.com/michelbr84/fluxswap-dex

# Pre-merge readiness check
/github-health pre-merge https://github.com/michelbr84/fluxswap-dex

# Post-merge follow-up
/github-health post-merge https://github.com/michelbr84/fluxswap-dex

# Release readiness
/github-health release-readiness https://github.com/michelbr84/fluxswap-dex
```

---

## Modes at a glance

| Mode | Purpose |
| --- | --- |
| `full` (default) | End-to-end audit across every dimension. |
| `quick` | High-signal triage: main branch, CI, open security alerts, top blockers. |
| `standard` | Most teams' default: full audit minus deep historical analysis. |
| `deep` | Full audit plus historical analysis, flake detection, churn, and trends. |
| `actions` | GitHub Actions, workflow health, required checks, permissions. |
| `branches` | Branch hygiene, stale/orphan/merged branches, naming risks. |
| `pulls` | PR triage, mergeability, reviews, traceability to issues/Linear. |
| `issues` | Backlog, labels, milestones, stale items, prioritization. |
| `security` | Umbrella security audit. |
| `code-scanning` | CodeQL and other code scanning alerts. |
| `dependabot` | Dependabot version and security alerts. |
| `secret-scanning` | Secret scanning alerts and rotation needs. |
| `dependency-graph` | Dependency graph, lockfiles, supply-chain risk. |
| `docs` | README, SECURITY, ROADMAP, CONTRIBUTING, CHANGELOG, CODEOWNERS, templates. |
| `releases` | Tags, releases, changelog, versioning, release notes. |
| `permissions` | Collaborators, teams, GitHub Apps, webhooks, environment protections. |
| `linear` | GitHub ↔ Linear sync, roadmap drift, auto-close risks. |
| `cleanup-plan` | Approval-gated cleanup plan for branches, PRs, issues, docs. |
| `pre-merge` | Should this PR be merged now? |
| `post-merge` | Did the merge land cleanly? Any follow-up needed? |
| `release-readiness` | Are we ready to cut a release today? |

---

## Expected inputs

- A GitHub repository URL (required).
- An optional mode (defaults to `full`).
- Optional scope hints, such as a PR number for `pre-merge`, a tag for `release-readiness`, or a branch name for branch-scoped runs.

---

## Expected outputs

Every audit produces a structured Markdown report following the **output contract** in `github-health/references/output-contract.md`:

```
# GitHub Health Report

Repository:
Date:
Mode:
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100

## Executive Summary
## Blockers
## Attention Needed
## Healthy Areas
## Detailed Findings
### Main Branch
### Actions
### Pull Requests
### Branches
### Issues
### Security
### Dependencies
### Documentation
### Releases
### Linear / Roadmap Sync
## Recommended Actions
### Do Now
### Do This Week
### Do Later
## Approval Required Before Destructive Actions
## Final Recommendation
```

Specialized skills produce a focused subset of the same contract, plus extra sections relevant to their scope. See `templates/` for ready-to-use forms.

---

## Safety guarantees

This skill set is **read-only by default**. It will never:

- delete branches
- merge or close pull requests
- close issues
- dismiss CodeQL, Dependabot, or secret scanning alerts
- change repository settings, branch protection, or rulesets
- modify Linear issues
- rotate or delete secrets
- create releases
- force-push or rewrite history

…without **explicit user approval** captured in the conversation. Any destructive action is listed under **Approval Required Before Destructive Actions** in the report and is never auto-executed.

The full safety policy lives in `github-health/references/safety-rules.md`.

---

## Linear integration

When Linear is available, the skill treats GitHub as the **technical** source of truth and Linear as the **operational** source of truth. The Linear audit detects:

- PRs without a linked Linear issue.
- Linear issues marked **In Progress** without an active branch or PR.
- Linear issues marked **Done** without merged PR evidence.
- Merged PRs whose Linear issue was not updated.
- `ROADMAP.md` drift from Linear initiatives, projects, or epics.
- Security follow-ups that should be tracked privately.
- Branch names or PR titles that could accidentally auto-close Linear issues.

See `skills/github-health-linear/SKILL.md`.

---

## Scoring

Every audit emits a 0–100 health score with the following weights:

| Area | Weight |
| --- | --- |
| Main branch and branch protection | 10 |
| Actions / CI | 15 |
| Pull requests | 10 |
| Branch hygiene | 10 |
| Security alerts | 20 |
| Dependencies | 10 |
| Documentation | 10 |
| Linear / roadmap sync | 10 |
| Releases / governance | 5 |

Override rules (cannot be GREEN if any apply): main is red, any open secret scanning alert, any open malware alert, any open critical Dependabot alert, untriaged high-severity CodeQL alerts. See `github-health/references/scoring-model.md`.

---

## Report examples

Illustrative reports are in `examples/`:

- `examples/full-audit-example.md`
- `examples/actions-only-example.md`
- `examples/security-only-example.md`
- `examples/branch-cleanup-example.md`
- `examples/linear-sync-example.md`
- `examples/pre-merge-example.md`
- `examples/post-merge-example.md`

Examples are clearly labeled as illustrative — they do **not** claim live data from any real repository.

---

## Roadmap

This repo is shipped in three phases.

### V1 — Markdown-only (current)

- All skills, agents, templates, examples, and evals are Markdown.
- The only executable code is a small `install.sh` for personal installation. No audit automation. No destructive operations.
- Claude does the inspection by hand using whatever read-only tools are available (local Git, GitHub CLI in read-only mode, GitHub UI, GitHub MCP, repository files).

### V2 — Command-guided

- Each skill suggests precise read-only commands the user can copy-paste.
- Output snippets the user pastes back become evidence the skill structures into the report.
- Still no destructive automation. Approval gates remain.

### V3 — Optional automation

- Optional executable scripts under explicit user opt-in.
- Strict allowlist of read-only operations.
- Destructive operations remain manual and approval-gated.
- Telemetry-free; no data leaves the repository.

---

## Contribution guidance

Contributions are welcome for:

- New specialized skills (e.g., supply-chain SBOM, infra-as-code review).
- Improvements to existing `SKILL.md` files (clearer triggers, better evidence lists).
- Additional templates and example reports.
- Eval prompts and expected-behavior cases.

Guidelines:

- Keep skills modular. One skill, one purpose.
- Keep `SKILL.md` files concise. Move long checklists to `references/`.
- Never introduce destructive defaults. Approval gates are non-negotiable.
- Avoid embedding private personal information in any file.
- Skill content is Markdown only in V1.

---

## Repository layout

```
github-health-claude-skills/
├── github-health/                 # Main orchestrator skill
│   ├── SKILL.md
│   └── references/
├── skills/                        # Specialized skills
├── agents/                        # Auditor personas
├── templates/                     # Reusable report templates
├── examples/                      # Illustrative example outputs
├── evals/                         # Evaluation prompts
├── README.md
├── SECURITY.md
├── LICENSE
└── CHANGELOG.md
```

---

## License

MIT — see [LICENSE](./LICENSE).
