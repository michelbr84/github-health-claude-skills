# Output Contract

Every audit report — regardless of mode — must follow the structure below. Specialized skills may omit subsections that do not apply, but the top-level layout stays the same.

## Required structure

```
# GitHub Health Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: <full | quick | standard | deep | actions | branches | pulls | issues | security |
       code-scanning | dependabot | secret-scanning | dependency-graph | docs |
       releases | permissions | linear | cleanup-plan | pre-merge | post-merge |
       release-readiness>
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100

## Executive Summary

A 3–6 sentence plain-English summary of overall health, headline risks, and the single
most important next action. No bullets, no jargon, no hedging.

## Blockers

Each blocker is a BLOCKER-severity finding that must be addressed before the repository
is considered healthy. Use the standard finding micro-format. If there are none, write
"None." explicitly.

## Attention Needed

HIGH and MEDIUM-severity findings. Group by area when there are many. If none, write
"None." explicitly.

## Healthy Areas

A short list of what is working well. Helps the reader understand what not to break.

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

For each subsection, list findings using the standard finding micro-format:

- [SEVERITY] Short title.
  Evidence: <verifiable observation>.
  Impact: <what this could cause>.
  Recommendation: <next step or action>.

If a subsection is `Not applicable`, say so explicitly with one line of justification.

## Recommended Actions

### Do Now

Concrete, non-destructive next steps that should be done today. Each item is one
imperative sentence.

### Do This Week

Concrete next steps to schedule within the week.

### Do Later

Improvements and hygiene items.

## Approval Required Before Destructive Actions

Any action that would mutate state goes here. Each item must include:

- The exact action (e.g., "delete branch `feature/x` after final merge confirmation").
- Why it is necessary.
- A one-line rollback or recovery note.

If there are none, write "None." explicitly.

## Final Recommendation

One paragraph. State the single most important thing the maintainer should do next, the
expected outcome, and whether to re-run a deeper audit afterward.
```

## Rules

1. Do not deviate from the section names or order.
2. Do not collapse `Approval Required Before Destructive Actions` into the regular action lists. It must remain a separate, visible block.
3. If `Mode` is narrow, keep only the relevant Detailed Findings subsections, but always keep `Executive Summary`, `Blockers`, `Attention Needed`, `Healthy Areas`, `Recommended Actions`, `Approval Required Before Destructive Actions`, and `Final Recommendation`.
4. Use the finding micro-format consistently:
   ```
   - [SEVERITY] Title.
     Evidence: …
     Impact: …
     Recommendation: …
   ```
5. Quote evidence where helpful (e.g., a workflow file path, a commit SHA, a PR number) but never quote secret values or tokens. Refer to secrets by ID only.
6. If a finding is unverified, mark it explicitly: `Evidence: Unverified — could not access <data>.`
7. Keep prose tight. Long lists belong in the appropriate subsection, not the executive summary.
