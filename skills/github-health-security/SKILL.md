---
name: github-health-security
description: "Run an umbrella security audit for a GitHub repository aggregating code scanning, Dependabot, secret scanning, malware alerts, repository security settings, SECURITY.md, and workflow permissions into one view. Use when the user wants the whole security picture; for a single dimension use child skills such as github-health-code-scanning, github-health-dependabot, or github-health-secret-scanning. Triggers on `/github-health security <repo>` and requests like \"is this repo secure\", \"audit security posture\", or \"what is our security debt\". Read-only; never dismisses alerts or changes settings without explicit approval."
---

# github-health-security

## When to trigger

- `/github-health security <repo>`
- Requests about overall security posture, audit, or "is this repo secure".

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 6.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Inspect security settings (`security_and_analysis`):
   - Code scanning enabled.
   - Secret scanning enabled.
   - Push protection enabled.
   - Private vulnerability reporting enabled.
   - Dependabot version and security updates enabled.
2. Count open alerts by category and severity:
   - Code scanning (CodeQL).
   - Dependabot — **always paginated** (`--paginate` with `per_page=100`); see `github-health-dependabot/SKILL.md` and `collection-guide.md`. A non-paginated call truncates at 30 items and must not be used for any count, severity, or manifest breakdown.
   - Secret scanning.
   - Malware (a special class of Dependabot alerts; same pagination rule applies).
3. Inspect `SECURITY.md`:
   - Present and current?
   - Reporting channel clearly described?
   - Disclosure policy included?
4. Inspect workflow permissions across `.github/workflows/`:
   - Default `GITHUB_TOKEN` permissions.
   - Per-workflow `permissions:` blocks.
   - Secrets referenced and not echoed.
5. Inspect branch protection on the default branch.
6. Score the Security area (weight 20) per `scoring-model.md`.
7. Render a report focused on **Security**.

## Evidence to collect

```
gh api repos/<owner>/<repo> --jq '.security_and_analysis'
gh api --paginate "repos/<owner>/<repo>/code-scanning/alerts?state=open&per_page=100"
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100"
gh api --paginate "repos/<owner>/<repo>/secret-scanning/alerts?state=open&per_page=100"
ls -la SECURITY.md
ls -la .github/workflows
```

> The `repos/<owner>/<repo>/dependabot/alerts` endpoint silently truncates to a single page (default 30 items). For any Dependabot count, severity breakdown, or manifest breakdown reproduced in the security report, use `--paginate` with `per_page=100`. If the GitHub UI count and API count disagree, re-run paginated and treat the mismatch as a verification issue. See `github-health-dependabot/SKILL.md` for the full PowerShell and POSIX command set.

## Red flags

- [BLOCKER] Open secret scanning alerts.
- [BLOCKER] Open malware alerts.
- [BLOCKER] Critical Dependabot alerts open with no triage record.
- [HIGH] CodeQL high-severity alerts open and untriaged.
- [HIGH] Branch protection missing on the default branch of a serious project.
- [HIGH] No `SECURITY.md`.
- [HIGH] Workflow grants `write` on `contents` or `actions` when not needed.
- [MEDIUM] Push protection disabled.
- [MEDIUM] Secret scanning disabled.
- [MEDIUM] Code scanning disabled (when applicable to the language).
- [MEDIUM] Private vulnerability reporting disabled.
- [LOW] `SECURITY.md` is generic or out of date.

## Output format

Use the standard contract. Populate **Detailed Findings → Security** in depth, with subsections for code scanning, Dependabot, secret scanning, and settings. The other Detailed Findings subsections may be marked `Not inspected (security-only mode)`.

## Safety rules

- Never dismiss, acknowledge, or otherwise modify any alert.
- Never approve a secret scanning bypass.
- Never change security settings, branch protection, or rulesets.
- Never echo secret values or token contents.
- Recommendations to dismiss alerts must go under **Approval Required Before Destructive Actions** with rationale and a one-line recovery note.

## When to escalate

- For deep CodeQL inspection: `github-health-code-scanning`.
- For Dependabot inspection: `github-health-dependabot`.
- For secret scanning specifics: `github-health-secret-scanning`.
- For permissions specifics: `github-health-permissions`.

## What not to do

- Do not declare GREEN while any open secret scanning alert, malware alert, or critical Dependabot alert exists.
- Do not paraphrase secret values into the report. Use alert IDs only.
- Do not recommend pushing tokens or `.env` files into private storage as a "fix" — recommend rotation and removal-from-history workflows manually.
