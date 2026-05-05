---
name: github-health-issues
description: "Audit GitHub issues: backlog size, label hygiene, milestones, stale issues, duplicates, missing prioritization, and bug-report quality. Triggers on `/github-health issues <repo>` and requests like \"review the backlog\", \"are issues being triaged\", or \"what issues are stale\". Read-only; never closes issues without explicit approval."
---

# github-health-issues

## When to trigger

- `/github-health issues <repo>`
- Requests about backlog hygiene, triage, stale issues, label or milestone usage.

## Required inputs

- GitHub repository URL.
- Optional: a label or milestone to focus on.
- Optional: stale threshold in days (default: 90).

## Reference files

- `github-health/references/github-health-checklist.md` — Section 5.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. List open issues with labels, milestones, and assignees.
2. List the label set; flag missing standard labels (e.g., `bug`, `enhancement`, `security`, `good first issue`).
3. List milestones; flag stale or empty milestones.
4. Detect issues:
   - Without labels.
   - Without milestones (where milestones are used).
   - With label `bug` but missing reproduction steps in body.
   - With label `security` filed publicly that should likely be private.
   - Stale (no activity > threshold).
   - Duplicate candidates (heuristic: similar titles).
5. Score the Issues area (part of the documentation/process bucket — weight 10 split with docs) per `scoring-model.md`.
6. Render a report focused on **Issues**.

## Evidence to collect

```
gh issue list --state open --limit 500 --json number,title,labels,milestone,assignees,createdAt,updatedAt,body
gh label list
gh api repos/<owner>/<repo>/milestones --jq '.[] | {title,state,due_on}'
```

## Red flags

- [HIGH] Issue labeled `security` filed publicly with sensitive details that should be private.
- [HIGH] Many critical bug issues without assignees.
- [MEDIUM] More than 50% of open issues have no label.
- [MEDIUM] Stale issues > 50% of total open.
- [MEDIUM] Milestones unused or stale (no due date, no progress).
- [LOW] Inconsistent label naming (`bug` vs `Bug` vs `type:bug`).
- [LOW] Duplicate-candidate clusters detected.
- [INFO] Backlog grows faster than it closes over the audit window.

## Output format

Use the standard contract. Populate **Detailed Findings → Issues** in depth. Provide grouped sub-tables when many issues share an attribute (e.g., "Issues missing labels", "Stale issues", "Bug issues without repro").

## Safety rules

- Never close, re-open, label, or comment on issues from this skill.
- Recommendations to close stale issues are listed under **Approval Required Before Destructive Actions** with a rationale and a recovery note ("issues can be re-opened from the GitHub UI").
- Public security issues get a special note: do **not** suggest re-publishing the content; instead recommend the user move the report to the repository's private vulnerability reporting channel.

## When to escalate

- If you find evidence of leaked secrets in issue bodies, escalate to `github-health-secret-scanning` and treat as a BLOCKER.
- If the backlog appears to drive the roadmap and Linear is in use, escalate to `github-health-linear`.

## What not to do

- Do not recommend "close all stale issues" as a blanket policy. Stale is not synonymous with invalid.
- Do not include personal emails or phone numbers from issue bodies in the report.
