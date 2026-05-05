---
name: github-health-docs
description: Audit project documentation — README, SECURITY, ROADMAP, CONTRIBUTING, CHANGELOG, CODEOWNERS, issue and PR templates, and freshness signals. Triggers on /github-health docs <repo> and on requests like "is the README current", "do we have CONTRIBUTING", "audit our documentation". Read-only; never edits docs.
---

# github-health-docs

## When to trigger

- `/github-health docs <repo>`
- Questions about documentation completeness, freshness, or onboarding readiness.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 12.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Confirm presence of the standard documentation set:
   - `README.md`
   - `SECURITY.md`
   - `ROADMAP.md`
   - `CONTRIBUTING.md`
   - `CHANGELOG.md`
   - `CODEOWNERS` (root or `.github/`)
   - `.github/ISSUE_TEMPLATE/` (one or more templates)
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `LICENSE`
2. Read each file (or its first 100 lines) and judge:
   - Is it boilerplate or substantively customized?
   - Are command examples consistent with current code?
   - Are versions, paths, and URLs current?
3. Cross-check `CHANGELOG.md` against the latest release tag — drift is a finding.
4. Cross-check `ROADMAP.md` against open milestones and (when available) Linear initiatives.
5. Score the Documentation area (weight 10) per `scoring-model.md`.
6. Render a report focused on **Documentation**.

## Evidence to collect

```
ls -la README.md SECURITY.md ROADMAP.md CONTRIBUTING.md CHANGELOG.md CODEOWNERS LICENSE .github/ISSUE_TEMPLATE .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null
git log -1 --pretty=format:"%cs" -- README.md
```

## Red flags

- [HIGH] No `SECURITY.md`.
- [HIGH] `README.md` references commands or paths that no longer exist.
- [MEDIUM] No `CONTRIBUTING.md` on a public project.
- [MEDIUM] No `CHANGELOG.md` or it is far behind the latest release.
- [MEDIUM] `CODEOWNERS` empty or missing important paths.
- [MEDIUM] No PR template.
- [MEDIUM] No issue templates.
- [LOW] `ROADMAP.md` empty or generic.
- [LOW] Doc files unchanged for > 1 year while code changes frequently.
- [INFO] Repository description and topics empty.

## Output format

Use the standard contract. Populate **Detailed Findings → Documentation** in depth. Use a per-file table: file path, present?, last updated, judgment, recommendation.

## Safety rules

- Never edit documentation in this skill.
- Recommendations to update a doc are listed in `Do This Week` / `Do Later`. They are not destructive and do not require an approval block, but they should still be precise about which file and which section.
- Recommendations to **delete** outdated or redundant docs (e.g., abandoned `ROADMAP-OLD.md`) go under **Approval Required Before Destructive Actions**.

## When to escalate

- If `SECURITY.md` is missing, this directly impacts the security score; flag in `github-health-security`.
- If `ROADMAP.md` drifts heavily from Linear, escalate to `github-health-linear`.
- If `CODEOWNERS` covers nothing important, escalate to `github-health-permissions`.

## What not to do

- Do not auto-generate doc bodies and present them as if they were existing.
- Do not assume a missing file is "fine" because the repo is small. State the impact and let the user decide.
- Do not include personal email addresses or phone numbers from any doc in the report.
