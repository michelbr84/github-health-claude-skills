# Severity Model

Every finding in the report carries a severity. Use the most specific level that fits.

| Severity | Meaning | Examples |
| --- | --- | --- |
| **BLOCKER** | Must be fixed now. The repository is unsafe, broken, or non-shippable until resolved. | Open secret scanning alert. Open malware alert. Critical Dependabot alert with public exploit. Default branch CI red on a serious project. Force-push detected on protected branch. |
| **HIGH** | Important and should be addressed soon (this week). | Branch protection missing on a serious project. Untriaged high-severity CodeQL alert. Stale lockfile referenced by Dependabot security update. PR mergeable but required checks pending. |
| **MEDIUM** | Should be scheduled. Not currently dangerous but accumulates risk. | Stale PRs without recent activity. Missing `CONTRIBUTING.md`. Workflow uses floating `@main` for third-party actions. Many unlabeled issues. |
| **LOW** | Improvement or hygiene item. | Stale merged branches not yet deleted. Missing repository topics. README slightly out of date. |
| **INFO** | Useful observation that informs context, not a bug. | Repository has only one contributor in last 90 days. Latest release was N months ago. Linear is not used (so Linear section is N/A). |

## Severity vs. status

Severity is per-finding. Status is repository-wide. The relationship:

- A single BLOCKER → status is **RED**.
- One or more HIGH findings → status is at least **YELLOW** (often higher when combined).
- Only MEDIUM/LOW/INFO findings → status can be **GREEN** if no override rules apply.

## Writing a severity-tagged finding

Every finding should follow this micro-format:

```
- [SEVERITY] Short title.
  Evidence: <verifiable observation>.
  Impact: <what this could cause>.
  Recommendation: <next step or action>.
```

If the recommendation is destructive, do **not** mark it as a Do-Now action. Place it under **Approval Required Before Destructive Actions** instead.

## Edge cases

- **Unverified findings.** When you cannot access the data needed to confirm a finding, mark severity as **INFO** and label the finding `Unverified`. Do not invent severity.
- **Triaged but not fixed.** If a high-severity alert has been intentionally triaged with a documented plan and timeline, downgrade it from HIGH to MEDIUM and note the triage record.
- **External-only risk.** If a risk only matters when the repository is public or has external users, state the precondition in the finding so the user can judge applicability.
