---
name: github-health-code-scanning
description: "Audit CodeQL and other code scanning alerts in a GitHub repository: open alerts by severity, dismissed alerts with reasons, false-positive handling, and remediation tracking. Triggers on `/github-health code-scanning <repo>` and requests like \"review CodeQL findings\", \"what SAST alerts are open\", or \"audit static-analysis results\". Read-only; never dismisses alerts."
---

# github-health-code-scanning

## When to trigger

- `/github-health code-scanning <repo>`
- Questions about CodeQL or third-party SAST results, alert triage, or remediation.

## Required inputs

- GitHub repository URL.
- Optional: severity filter (e.g., `critical`, `high`).

## Reference files

- `github-health/references/github-health-checklist.md` — Section 7.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Confirm code scanning is enabled.
2. Identify which scanners are configured (CodeQL, third-party).
3. List open alerts by severity (`critical`, `high`, `medium`, `low`).
4. List dismissed alerts and the dismissal reason for each.
5. Detect false-positive patterns: alerts dismissed without a reason, or alerts repeatedly re-opened.
6. Cross-reference open high-severity alerts against tracked issues or Linear tickets — flag any that are untracked.
7. Score the impact on the Security area (part of the weight 20) per `scoring-model.md`.
8. Render a report focused on **Security → Code Scanning**.

## Evidence to collect

```
gh api repos/<owner>/<repo>/code-scanning/alerts?state=open
gh api repos/<owner>/<repo>/code-scanning/alerts?state=dismissed
gh api repos/<owner>/<repo>/code-scanning/analyses?per_page=10
```

For each alert, capture: alert number, rule ID, severity, location (file + line), state, created date.

## Red flags

- [BLOCKER] Critical-severity alert open without triage on a public repository.
- [HIGH] High-severity alert open without a tracked remediation plan.
- [HIGH] Repeated dismissal of the same rule without a reason ("won't fix" used as a default).
- [MEDIUM] Code scanning disabled for a language that has CodeQL coverage.
- [MEDIUM] No analysis run in > 30 days on default branch.
- [LOW] Many low-severity alerts; review prioritization.
- [INFO] Third-party SAST output not normalized into GitHub code scanning.

## Output format

Use the standard contract. Populate **Detailed Findings → Security → Code Scanning** in depth. Provide three sub-tables when applicable: open by severity, dismissed by reason, untracked open alerts.

## Safety rules

- Never dismiss, re-open, or modify an alert.
- Never propose dismissing a critical or high-severity alert without explicit approval and a documented justification.
- Recommendations to dismiss go under **Approval Required Before Destructive Actions** with rationale, justification reason (e.g., `false positive`, `won't fix`), and a one-line recovery note.

## When to escalate

- If many open alerts exist across the codebase, recommend `/github-health full <repo>` to evaluate other security signals together.
- If alerts cluster around a single dependency, escalate to `github-health-dependabot` and `github-health-dependency-graph`.

## What not to do

- Do not classify severity by hand — use the severity assigned by the scanner.
- Do not propose code changes that "silence" an alert without addressing the underlying finding.
