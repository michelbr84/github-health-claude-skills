# Example — Pre-Merge (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository.

# Pre-Merge Report

Repository: michelbr84/GarraRUST
PR: #198 — "Voxel streaming chunked loader"
Date: 2026-05-05
Mode: pre-merge
Overall Status: YELLOW
Merge Recommendation: NOT YET

## Executive Summary

PR #198 is mergeable with no conflicts and one approving review, but the `coverage` required check is still pending. Per the safety rules, merging is not recommended while any required check is pending. Wait for `coverage` to complete before re-running this audit.

## Snapshot

- Mergeable state: clean
- Required check status: one `pending` (`coverage`); others `success`
- Review decision: approved (1 of 1 required)
- Conflicts: no
- Linked Linear: `GARRA-110` (in PR body)
- Auto-close risk: no
- Branch base: `main` (default)

## Blockers

- [BLOCKER] Required check `coverage` is `pending`.
  Evidence: `gh pr view 198 --json statusCheckRollup` shows `coverage` `IN_PROGRESS`.
  Impact: Merging now would bypass the required signal.
  Recommendation: Wait for `coverage` to complete; do not bypass.

## Attention Needed

None.

## Detailed Findings

### Required checks

| Check | State | Run URL/ID | Notes |
| --- | --- | --- | --- |
| `lint` | success | run-220011 | — |
| `unit` | success | run-220012 | — |
| `integration` | success | run-220013 | — |
| `coverage` | pending | run-220014 | In progress; ~6 minutes remaining |

### Reviews

| Reviewer | Decision | Last activity |
| --- | --- | --- |
| `@reviewer-a` | approved | 2026-05-05 09:14Z |

### Conflicts

None.

### Traceability

| Source | Reference | OK |
| --- | --- | --- |
| Linked issue | none | N |
| Linked Linear | `GARRA-110` | Y |
| Auto-close substring | not found | Y |

### Quick CI signal

- Default branch CI: green
- This PR's HEAD CI: pending (driven by `coverage`)

## Recommended Actions

### Do Now

- Wait for `coverage` (run-220014) to complete.
- After completion, re-run `/github-health pre-merge https://github.com/michelbr84/GarraRUST 198`.

### Do This Week

- Consider linking the PR to a GitHub issue in addition to Linear `GARRA-110`.

## Approval Required Before Destructive Actions

(No merge action listed because Merge Recommendation is `NOT YET`.)

## Final Recommendation

**WAIT.** The single signal to wait for is the `coverage` required check. After `coverage` reports `success`, re-run this audit. If everything is green and reviews still satisfy the rule, this PR will be SAFE to merge — at which point the user can approve the merge action explicitly.
