---
name: github-health-pulls
description: "Audit the set of open pull requests in a GitHub repository: mergeability, checks, reviews, conflicts, staleness, and traceability to issues or Linear. Triggers on `/github-health pulls <repo>` and requests like \"review my open PRs\", \"what PRs are stuck\", or \"audit the PR backlog\". For a single-PR readiness check, use `/github-health pre-merge` instead. Read-only; never merges or closes PRs without explicit approval."
---

# github-health-pulls

## When to trigger

- `/github-health pulls <repo>`
- Requests about PR triage, mergeability, stuck PRs, or PR/Linear traceability.

## Required inputs

- GitHub repository URL.
- Optional: a specific PR number for focused analysis (use `pre-merge` skill if the question is "should I merge this now?").

## Reference files

- `github-health/references/github-health-checklist.md` — Section 3.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. List open PRs (including drafts).
2. For each PR, capture:
   - Number, title, author.
   - Created and last-updated dates.
   - Mergeable state.
   - Required check status (`success`, `failure`, `pending`, missing).
   - Review decision (`approved`, `changes_requested`, `review_required`).
   - Conflicts with base.
   - Linked issue or Linear ticket.
   - Branch name (and whether it implies an auto-close).
3. Classify each PR:
   - **Ready** — mergeable, checks green, reviews satisfied.
   - **Blocked by checks** — failing or pending required checks.
   - **Blocked by review** — changes requested or no reviewer assigned.
   - **Conflict** — mergeable state is `dirty`.
   - **Stale** — no activity past threshold (default 14 days for non-draft, 30 for draft).
   - **Abandoned** — author inactive > 60 days, no progression.
4. Detect PRs that lack any link to an issue or Linear ticket.
5. Score the Pull requests area (weight 10) per `scoring-model.md`.
6. Render a report with one row per PR in the **Pull Requests** subsection.

## Evidence to collect

```
gh pr list --state open --limit 200 --json \
  number,title,author,createdAt,updatedAt,isDraft,mergeable,reviewDecision,statusCheckRollup,headRefName,baseRefName,body
```

For Linear linkage, search the title and body for Linear issue IDs (e.g., `PROJ-123`).

## Red flags

- [HIGH] PR is mergeable but at least one required check is `pending`. **Do not recommend merge.**
- [HIGH] PR has been open > 60 days without merge or close.
- [HIGH] PR title or body could auto-close a Linear issue (`Closes PROJ-123`) but the work is not actually complete.
- [MEDIUM] PR has no linked issue or Linear ticket.
- [MEDIUM] PR has merge conflicts.
- [MEDIUM] PR has changes requested with no follow-up commit in > 14 days.
- [LOW] PR title is non-descriptive (`update`, `fix`, `wip`).
- [INFO] Draft PR active for an extended period.

## Output format

Use the standard contract. Populate **Detailed Findings → Pull Requests** in depth. For each PR, use the standard finding micro-format and include the PR number and title.

## Safety rules

- Never merge, close, re-open, or convert PRs.
- "Should I merge?" questions for a single PR should be answered with the **pre-merge** skill, not this one.
- Recommendations to close abandoned PRs go under **Approval Required Before Destructive Actions** with a one-line rollback note ("can be re-opened from the GitHub UI within 30 days").

## When to escalate

- If many PRs are blocked by the same failing check, escalate to `github-health-actions`.
- If many PRs lack Linear links, escalate to `github-health-linear`.
- If the entire backlog suggests systemic process drift, recommend `/github-health full <repo>`.

## What not to do

- Do not recommend merging PRs with pending checks. Period.
- Do not infer merge readiness from "looks fine" — base it on explicit signals.
- Do not mention reviewers or authors in personal terms beyond their GitHub handle.
