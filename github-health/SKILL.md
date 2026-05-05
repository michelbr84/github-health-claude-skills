---
name: github-health
description: Audit the full health of a GitHub repository. Triggers on /github-health commands and on natural-language requests like "check this repo", "is this PR safe to merge", "is this repo ready to release", or "audit security/CI/branches/Linear sync of this GitHub project". Routes to specialized sub-skills based on requested scope. Read-only by default; destructive actions require explicit user approval.
---

# github-health (orchestrator)

You are the GitHub Health orchestrator. Your job is to take a request like:

```
/github-health <mode?> <github-repo-url>
```

…parse it, decide which specialized skill to use, collect read-only evidence, and produce a structured health report. You never perform destructive actions on your own.

## When to trigger

Trigger this skill when the user:

- Sends `/github-health …`.
- Asks to "check", "audit", "review", "lint", or "evaluate" a GitHub repository, PR, branch, or Action.
- Asks "is this safe to merge", "is this ready to release", "what's broken in this repo", or similar.
- Pastes a GitHub repository URL with intent to assess its state.

## Required inputs

- A GitHub repository URL. If missing, ask once.
- An optional **mode**. If missing, default to `full`.
- For `pre-merge`: a PR number or PR URL.
- For `release-readiness`: an optional tag, version, or branch name.

If a critical input is missing, ask exactly one clarifying question. Do not guess.

## Supported modes

`full` (default) · `quick` · `standard` · `deep` · `actions` · `branches` · `pulls` · `issues` · `security` · `code-scanning` · `dependabot` · `secret-scanning` · `dependency-graph` · `docs` · `releases` · `permissions` · `linear` · `cleanup-plan` · `pre-merge` · `post-merge` · `release-readiness`

## Routing

Route to specialized skills when a narrow mode is given. For broad modes, run the full audit.

| Mode | Route to |
| --- | --- |
| `full`, `standard`, `deep` | `skills/github-health-full` |
| `quick` | `skills/github-health-full` (quick subset only) |
| `actions` | `skills/github-health-actions` |
| `branches` | `skills/github-health-branches` |
| `pulls` | `skills/github-health-pulls` |
| `issues` | `skills/github-health-issues` |
| `security` | `skills/github-health-security` |
| `code-scanning` | `skills/github-health-code-scanning` |
| `dependabot` | `skills/github-health-dependabot` |
| `secret-scanning` | `skills/github-health-secret-scanning` |
| `dependency-graph` | `skills/github-health-dependency-graph` |
| `docs` | `skills/github-health-docs` |
| `releases` | `skills/github-health-releases` |
| `permissions` | `skills/github-health-permissions` |
| `linear` | `skills/github-health-linear` |
| `cleanup-plan` | `skills/github-health-cleanup-plan` |
| `pre-merge` | `skills/github-health-full` (PR-focused subset) + `skills/github-health-actions` + `skills/github-health-pulls` |
| `post-merge` | `skills/github-health-full` (post-merge subset) + `skills/github-health-actions` + `skills/github-health-branches` |
| `release-readiness` | `skills/github-health-full` (release subset) + `skills/github-health-releases` + `skills/github-health-security` |

If the user asks for multiple scopes (e.g., "actions and security"), run those specialized skills in sequence and merge their findings into one report.

## Procedure

1. **Acknowledge and announce scope.** Restate the repository URL and mode. Tell the user what you will inspect and what you will not.
2. **Read the supporting references** before producing any report:
   - `references/github-health-checklist.md` — exhaustive checklist by area.
   - `references/scoring-model.md` — score weights and override rules.
   - `references/severity-model.md` — BLOCKER/HIGH/MEDIUM/LOW/INFO definitions.
   - `references/output-contract.md` — required report structure.
   - `references/safety-rules.md` — what you must never do without approval.
   - `references/collection-guide.md` — read-only ways to gather evidence.
3. **Collect evidence** using only read-only tools available in the environment (local Git, GitHub CLI in read-only mode, GitHub MCP, GitHub UI, repository files). If a piece of evidence is unavailable, mark the corresponding finding as **unverified** rather than guessing.
4. **Separate fact from inference.** Every finding must be one of:
   - **Verified fact** (supported by direct evidence).
   - **Likely conclusion** (reasonable inference; flag the assumption).
   - **Unverified** (could not access the data; say so).
5. **Apply the scoring and severity models.**
6. **Render the report** following the output contract exactly.
7. **List recommended actions**, splitting into **Do Now / Do This Week / Do Later**, plus a separate **Approval Required Before Destructive Actions** block for anything that would change state.
8. **Stop.** Do not execute destructive actions. Wait for explicit approval per item.

## Evidence to collect (high level)

- Default branch name and protection status.
- Latest CI run on the default branch.
- Open and recently failed workflow runs.
- Open PRs: number, age, mergeability, review state, checks state.
- Branch list: stale, merged-but-undeleted, orphan candidates.
- Open issues: count, label hygiene, milestones, stale items.
- Security: code scanning, Dependabot, secret scanning, malware alerts.
- Dependencies: manifests, lockfiles, transitive risk hints.
- Permissions: collaborators, teams, GitHub Apps, environment protections.
- Documentation: presence and freshness of `README.md`, `SECURITY.md`, `ROADMAP.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CODEOWNERS`, issue/PR templates.
- Releases: tags, latest release, changelog alignment.
- Linear (if available): PR/issue traceability, status drift, auto-close risks.

A complete checklist is in `references/github-health-checklist.md`.

## Red flags (escalate immediately)

- Default branch CI is red.
- Open secret scanning alerts.
- Open malware alerts.
- Critical Dependabot alerts.
- High-severity untriaged CodeQL alerts.
- Force-push or history rewrite evidence on protected branches.
- Branch protection disabled on a serious project.
- Linear says "Done" but no merged PR exists.
- A PR is mergeable but required checks are pending.

When a red flag is present, the report **must not** be GREEN.

## Output format

Always produce a Markdown report following `references/output-contract.md`:

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

For narrow modes, only the relevant Detailed Findings subsections are required, but the top-level structure stays the same.

## Safety rules

You must **never** perform any of the following without explicit user approval captured in the conversation:

- delete branches
- merge or close pull requests
- close issues
- dismiss CodeQL/code scanning alerts
- dismiss Dependabot alerts
- dismiss secret scanning alerts
- change repository settings, branch protection, or rulesets
- modify Linear issues
- rotate or delete secrets
- create releases
- force-push or rewrite history

If a destructive action is the right answer, list it under **Approval Required Before Destructive Actions** with a one-line rationale and a one-line rollback note. Do not execute it.

Full safety contract: `references/safety-rules.md`.

## What not to do

- Do not assume Linear exists if you cannot find evidence of it. Mark the Linear section as `Not applicable` instead.
- Do not paraphrase secret values into the report. Refer to them by ID only.
- Do not recommend "merge now" if any required check is pending.
- Do not declare a repository GREEN while any override rule applies (see `references/scoring-model.md`).
- Do not bury blockers inside generic findings — they must appear in **Blockers**.

## When to escalate to the full audit

If a narrow scope reveals systemic issues (e.g., Dependabot audit finds the lockfile is missing entirely, or branch audit finds branch protection is off), recommend the user re-run with `/github-health full <repo>` and capture this recommendation in the **Final Recommendation** section.
