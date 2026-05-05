---
name: github-health-branches
description: "Audit GitHub branch hygiene: merged branches, stale branches, orphan branches, branches behind main, branch naming risks, and branch cleanup candidates. Triggers on `/github-health branches <repo>` and requests like \"review branches\", \"which branches can I delete\", \"branch cleanup\", or \"are there stale branches\". Use this for branch-only cleanup; for cross-cutting cleanup (branches + PRs + issues + docs + security + Linear) use github-health-cleanup-plan instead. Read-only; never deletes branches without explicit approval."
---

# github-health-branches

## When to trigger

- `/github-health branches <repo>`
- Requests about branch cleanup, stale branches, orphan branches, or naming risks.

## Required inputs

- GitHub repository URL.
- Optional: a "stale" threshold in days (default: 60).

## Reference files

- `github-health/references/github-health-checklist.md` — Section 4.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Fetch all remote refs (`git fetch --all --prune`).
2. List branches with last-commit date and author.
3. Determine which branches are merged into the default branch and which are not.
4. Classify each branch:
   - **Active** — recent commits and an open PR or recent activity.
   - **Merged-undeleted** — merged into default, no longer needed.
   - **Stale** — no activity past the threshold and no open PR.
   - **Orphan** — no associated PR, ahead of default, no recent activity.
   - **Long-lived feature** — open PR but diverging significantly from default.
5. Inspect branch names for risk patterns:
   - Names that include `Closes #N`, `Fixes #N`, or Linear-style IDs that could trigger auto-close on push or merge.
   - Names that imply security context but are not in a private workflow.
6. Score the Branch hygiene area (weight 10) per `scoring-model.md`.
7. Produce a **cleanup candidates** list with severity and rationale.
8. Surface deletions only under **Approval Required Before Destructive Actions**.

## Evidence to collect

```
git fetch --all --prune
git for-each-ref --sort=-committerdate refs/remotes/origin \
  --format="%(committerdate:iso8601) %(refname:short) %(authorname)"
git branch -r --merged origin/<default>
git branch -r --no-merged origin/<default>
gh pr list --state open --json number,headRefName,baseRefName,updatedAt
```

## Red flags

- [HIGH] Long-lived branch (>60 days) with significant divergence and no open PR.
- [MEDIUM] Branch merged into default but not deleted, > 30 days.
- [MEDIUM] Many orphan branches relative to active development.
- [MEDIUM] Inconsistent naming (mix of `feat/`, `feature/`, `f-`, none).
- [LOW] Personal/scratch branches (`tmp/foo`, `wip/x`) older than 30 days.
- [HIGH] Branch name contains `Closes <linear-id>` or `Fixes #N` and is open against default — risk of accidental auto-close on merge.

## Output format

Use the standard contract. Populate **Detailed Findings → Branches** in depth, plus a clearly labeled **Cleanup Candidates** subsection inside it. Each candidate row should include:

- Branch name.
- Last commit date and author.
- Status (merged / stale / orphan / long-lived).
- Recommendation (delete after final confirmation, leave, or escalate).
- A one-line rollback note if deletion is recommended.

## Safety rules

- Never delete a branch in this skill, ever.
- All deletions are listed under **Approval Required Before Destructive Actions**.
- Recommend `git push origin --delete <branch>` only as a manual command for the user to run after their explicit confirmation.
- Always note recovery options (e.g., "branch ref can be restored from `git reflog` or from the merge commit's parent").

## When to escalate

If branch protection is absent or the default branch contains direct pushes from many contributors, recommend `/github-health full <repo>` to inspect protection and CI as well.

## What not to do

- Do not bulk-recommend deletion of every branch matching a pattern. Each recommendation must be evaluated individually with evidence.
- Do not assume "merged" implies "safe to delete" — if the branch is referenced by a release tag, deployment, or downstream fork, deletion may break links.
