---
name: github-health-dependabot
description: Audit Dependabot alerts and PRs — severity counts, affected packages, manifest and lockfile coverage, malware alerts, version vs. security updates configuration. Triggers on /github-health dependabot <repo> and on requests about Dependabot alerts, vulnerable dependencies, or supply-chain risk via Dependabot. Read-only; never dismisses alerts or merges PRs.
---

# github-health-dependabot

## When to trigger

- `/github-health dependabot <repo>`
- Questions about Dependabot alerts, vulnerable dependencies, or Dependabot PR backlog.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 8.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Confirm Dependabot is enabled (version updates, security updates).
2. Read `.github/dependabot.yml` if present and validate ecosystems covered.
3. List open Dependabot alerts by severity.
4. Identify any **Dependabot malware** alerts — these are the highest priority and must always be a BLOCKER.
5. List open Dependabot PRs and classify:
   - Mergeable, checks green.
   - Failing checks.
   - Conflict.
   - Stale (no activity > 14 days).
6. Cross-check coverage:
   - Are all manifest files in the repo covered by `dependabot.yml`?
   - Are all relevant lockfiles present?
7. Score the Dependencies and Security areas per `scoring-model.md`.
8. Render a report focused on **Dependencies** and the **Dependabot** subsection of Security.

## Evidence to collect

```
gh api repos/<owner>/<repo>/dependabot/alerts?state=open
gh pr list --search "is:open author:app/dependabot" --json number,title,createdAt,updatedAt,mergeable,statusCheckRollup
ls -la .github/dependabot.yml
```

Inspect manifest and lockfile coverage in the working copy: `package.json`, `Cargo.toml`, `requirements.txt`, `pyproject.toml`, `go.mod`, etc., and corresponding lockfiles.

## Red flags

- [BLOCKER] Any open Dependabot **malware** alert.
- [BLOCKER] Critical-severity Dependabot alert with public exploit available.
- [HIGH] High-severity alert without a planned upgrade path.
- [HIGH] Lockfile missing for an ecosystem covered by Dependabot.
- [HIGH] Manifest files not covered by `dependabot.yml`.
- [MEDIUM] Many stale Dependabot PRs (> 14 days).
- [MEDIUM] Auto-merge enabled for Dependabot PRs (unsafe by default).
- [LOW] Lockfile present but very out of date.

## Output format

Use the standard contract. Populate **Detailed Findings → Dependencies** and the relevant Security subsections. Include a sub-table of open alerts: ID, package, ecosystem, severity, fixed version, advisory link.

## Safety rules

- Never dismiss a Dependabot alert.
- Never merge a Dependabot PR.
- Recommendations to dismiss or merge go under **Approval Required Before Destructive Actions**, with explicit rationale (e.g., "false positive — package not used at runtime") and a recovery note.
- Do not propose enabling Dependabot auto-merge in V1.

## When to escalate

- For supply-chain risk and abandoned dependencies → `github-health-dependency-graph`.
- For broader security context → `github-health-security`.

## What not to do

- Do not auto-classify a critical alert as "low impact" without documented justification from the user.
- Do not recommend pinning to old versions just to avoid breaking changes when a security fix is available.
