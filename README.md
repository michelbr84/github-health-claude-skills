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

### Saving reports

By default, audit reports are **shown in chat only** — no file is written. To persist a report to disk, append one of these flags:

```
# Print in chat AND save a Markdown copy to the default reports directory
/github-health quick https://github.com/michelbr84/fluxswap-dex --save

# Save only (chat shows a short summary plus the saved path)
/github-health full https://github.com/michelbr84/fluxswap-dex --save-only

# Save to a custom path (parent directories are created if needed)
/github-health actions https://github.com/michelbr84/fluxswap-dex --save-to .github-health-reports/actions.md
```

The default save path is:

```
.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-<mode>-health-report.md
```

For example:

```
.github-health-reports/michelbr84-fluxswap-dex/2026-05-05-quick-health-report.md
```

Save semantics:

- **Non-overwriting.** If the target file already exists, the skill stops and asks you to confirm overwrite, choose a new name, or skip saving.
- **Never auto-committed.** Saving writes the file to disk; it does not `git add` or commit anything.
- **Gitignored by default.** `.github-health-reports/` is listed in `.gitignore`, so default-path reports stay out of version control.
- **Saving inside a tracked folder warns first.** If you pass `--save-to <path>` somewhere that *is* tracked (e.g., `docs/`), the skill warns once that the report may contain sensitive security information before writing.

The full persistence contract — including the `Saved to:` metadata line and overwrite rules — lives in `github-health/references/output-contract.md`.

---

## `/github-health-improve` — apply the next score-improving fix

`/github-health` audits. **`/github-health-improve`** acts on the audit. It reads the most recent saved report, picks the next highest-leverage improvement that fits the chosen risk level, and (depending on flags) creates a non-`main` branch, edits files, runs local checks, commits, pushes, opens a PR, optionally merges if checks are green, then re-audits and produces a delta report. It is approval-gated by default and supports an autonomous ratchet loop under explicit flags. The full skill spec lives in `skills/github-health-improve/SKILL.md`.

### Modes

| Invocation | What happens |
| --- | --- |
| `/github-health-improve <repo>` | Default. Read the latest report, propose the next improvement, **stop and ask** before editing. |
| `/github-health-improve <repo> --auto` | Apply one in-scope improvement, branch, commit, push, open a PR, wait for Actions. **Does not merge.** |
| `/github-health-improve <repo> --auto --auto-merge` | Same as `--auto`, plus merge if every required check is green and the PR is mergeable. After merge, run `/github-health quick <repo> --save` and produce a delta report. |
| `/github-health-improve <repo> --dangerously-skip-approvals --auto --auto-merge --max-iterations <N>` | Autonomous ratchet loop up to N iterations (hard cap: 5). Skips the skill's between-step approval prompts only — see safety note below. |

### Flags

- `--auto` — apply one improvement automatically.
- `--auto-merge` — merge the PR only when all required checks are green and the branch is mergeable. Never merge red, pending, missing, skipped-in-required, or inconclusive.
- `--dangerously-skip-approvals` — skip the skill's *conversational* approval gates only. **Required:** must be combined with `--max-iterations` when `--auto-merge` is also present.
- `--max-iterations <N>` — maximum improvement cycles (default 1, hard maximum 5).
- `--target-score <N>` — stop once the verified score is ≥ N (default 100).
- `--risk-level low|medium|high` — controls which classes of improvement are allowed (default `low`).
- `--dry-run` — read reports and simulate the chosen loop without changing files.
- `--from-reports <path>` — explicit prior-report directory. Default is `.github-health-reports/<owner>-<repo>/`.
- `--save` — save improvement plan, execution summary, and delta report to disk (default path uses the same convention as the audit, with `improvement-`, `execution-`, and `delta-` prefixes).
- `--save-to <path>` — save the delta report to a custom path; if `<path>` is a directory, all three reports are written there.

### Risk levels

- **`low` (default).** `LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CODEOWNERS`, README fixes, `SECURITY.md` improvements, doc/report organization, GitHub Actions comment/naming-only edits, adding the **default** CodeQL workflow when language support is clear, and merging Dependabot PRs whose CI is already green.
- **`medium`.** All `low` plus: test-only changes, lint/format via existing tooling, CI workflow improvements (least-privilege `permissions:`, SHA pinning), non-major dependency bumps with lockfile updates, CodeQL workflow tuning.
- **`high`.** All `medium` plus: source-code changes, package upgrades not already proposed by Dependabot, build changes, security-remediation code changes.

### Hard safety rules (apply in every mode, including dangerous)

The skill **never**:

- force-pushes, rewrites history, deletes branches, deletes issues, closes PRs;
- dismisses Dependabot, CodeQL, secret scanning, or malware alerts;
- rotates, deletes, or adds secrets;
- weakens branch protection, repository security settings, or required-status-check rules;
- disables CI, tests, CodeQL, Dependabot, or secret scanning;
- merges with red, pending, missing, skipped-in-required, or inconclusive checks;
- merges directly to the default branch without a PR;
- modifies production deployment secrets or environment protections;
- commits `.env`, private keys, tokens, or generated health reports unless explicitly configured;
- claims a score improved without a fresh report — when the verification audit hasn't completed, the score change is reported as **estimated**.

### What `--dangerously-skip-approvals` actually does

It skips **only the skill's own conversational approval gates** between steps. It does **not** bypass:

- Claude Code permission prompts (enforced by the harness).
- Operating-system permissions.
- GitHub permissions (the `gh` token's scopes apply).
- Branch protection or required checks (enforced upstream by GitHub).
- Secret scanning push protection.
- Linear permissions or any other connector.
- Repository rulesets.
- Pre-commit / pre-push hooks (`--no-verify` is never used).

In other words, it is a *user-side* concession that the skill may proceed without re-prompting; it is not a privilege escalation against any external system.

### Examples (using FluxSwap as the canonical sample)

```
# Approval-gated — propose the next improvement and wait for user approval
/github-health-improve G:\Projetos\fluxswap-dex --from-reports G:\Projetos\fluxswap-dex\.github-health-reports

# One automatic improvement, no merge — branches, pushes, opens PR, waits for Actions
/github-health-improve G:\Projetos\fluxswap-dex --auto --risk-level low --max-iterations 1 --save

# Automatic merge if green — applies one improvement and merges only if all required checks pass
/github-health-improve G:\Projetos\fluxswap-dex --auto --auto-merge --risk-level low --max-iterations 1 --save

# Dangerous autonomous ratchet — up to 3 iterations, stop when score ≥ 95
/github-health-improve G:\Projetos\fluxswap-dex --dangerously-skip-approvals --auto --auto-merge --risk-level low --max-iterations 3 --target-score 95 --save
```

The skill works for any GitHub repository — FluxSwap is the canonical sample because the audit examples in this repo target it.

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
