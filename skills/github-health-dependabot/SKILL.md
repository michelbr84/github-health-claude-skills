---
name: github-health-dependabot
description: "Audit Dependabot alerts and PRs in a GitHub repository: severity counts, affected packages, manifest and lockfile coverage, malware alerts, and version-update versus security-update configuration. Use this for vulnerability alerts and Dependabot PR backlogs; for the dependency tree itself use github-health-dependency-graph. Triggers on `/github-health dependabot <repo>` and requests like \"what Dependabot alerts are open\", \"review vulnerable dependencies\", or \"is Dependabot configured\". Read-only; never dismisses alerts or merges PRs."
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
3. List open Dependabot alerts by severity. **Always use paginated API calls** (`--paginate` and `per_page=100`) — see *Pagination is mandatory* below.
4. Identify any **Dependabot malware** alerts — these are the highest priority and must always be a BLOCKER.
5. List open Dependabot PRs and classify:
   - Mergeable, checks green.
   - Failing checks.
   - Conflict.
   - Stale (no activity > 14 days).
6. Cross-check coverage:
   - Are all manifest files in the repo covered by `dependabot.yml`?
   - Are all relevant lockfiles present?
7. Score the Dependencies and Security areas per `scoring-model.md`. **Never compute or recalculate the score from a partial Dependabot page** — if pagination is uncertain, mark the score as `Unverified — pagination not confirmed` and re-collect.
8. Render a report focused on **Dependencies** and the **Dependabot** subsection of Security.

## Pagination is mandatory

The GitHub REST endpoint `repos/<owner>/<repo>/dependabot/alerts` returns at most 30 items by default and 100 per page with `per_page=100`. Repositories with many open alerts (FluxSwap had 71) are silently truncated when the request is made without pagination. **Any count, severity breakdown, or manifest breakdown derived from a non-paginated call is wrong and must not be reported as the total.**

Rules:

- Always combine `--paginate` with `per_page=100` for any Dependabot alert listing.
- A bare `gh api repos/<owner>/<repo>/dependabot/alerts` (no `--paginate`, no `per_page`) is **insufficient** for repositories with many alerts. Do not use it as the source of any count, severity table, or manifest table.
- If the GitHub UI count and the API count disagree, treat the mismatch as a verification issue: re-run with `--paginate "...?state=open&per_page=100"` and reconcile. State both numbers in the finding until they match.
- Do not extrapolate, estimate, or "round up" the alert count from a single page.

## Evidence to collect

PowerShell — open alert count:

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].number' | Measure-Object -Line
```

PowerShell — severity breakdown:

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].security_vulnerability.severity' | Sort-Object | Group-Object
```

PowerShell — manifest breakdown:

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].dependency.manifest_path' | Sort-Object | Group-Object
```

POSIX shell equivalents (counts, severity, manifest):

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].number' | wc -l
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].security_vulnerability.severity' | sort | uniq -c
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].dependency.manifest_path' | sort | uniq -c
```

Dependabot PRs and config:

```
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
- Do not report an alert count, severity breakdown, or manifest breakdown derived from a non-paginated `gh api repos/<owner>/<repo>/dependabot/alerts` call. Always use `--paginate` with `per_page=100`.
- Do not silently treat the first API page as the total. If the UI count differs from the API count, flag a verification issue and re-run paginated.
