# Branch Cleanup Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: branches
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100 (branches sub-score: <0-10>)

## Executive Summary

<2–4 sentences on branch hygiene state and the single most useful next action.>

## Snapshot

- Total branches: <n>
- Active: <n>
- Merged-undeleted: <n>
- Stale (>= <threshold> days, no PR): <n>
- Orphan: <n>
- Long-lived feature: <n>

## Blockers

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### Active branches

| Branch | Last activity | Author | Open PR | Notes |
| --- | --- | --- | --- | --- |
| <name> | <date> | <handle> | <#n / none> | <notes> |

### Merged-undeleted branches

| Branch | Merged on | Into | Recommendation | Rollback |
| --- | --- | --- | --- | --- |
| <name> | <date> | <default> | Candidate for deletion | `git push origin <name>` from local ref before deletion; reflog within retention window |

### Stale branches

| Branch | Last activity | Open PR | Recommendation |
| --- | --- | --- | --- |
| <name> | <date> | none | Verify with author before deletion |

### Orphan branches

| Branch | Last activity | Ahead of default | Recommendation |
| --- | --- | --- | --- |
| <name> | <date> | <n commits> | Tag as `archive/<name>` then delete after approval |

### Long-lived feature branches

| Branch | Open PR | Behind default | Ahead of default | Recommendation |
| --- | --- | --- | --- | --- |
| <name> | #<n> | <n> | <m> | Rebase or close PR; flag for owner review |

### Naming risks

| Branch | Pattern | Risk |
| --- | --- | --- |
| <name> | `Closes <LINEAR-ID>` in name | Could auto-close Linear on merge |

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

- Action: Delete remote branch `<name>`.
  Target: `origin/<name>`.
  Why: Merged into default on <date>; no downstream references.
  Rollback: Restorable from `git reflog` within retention window, or from the merge commit's parent SHA.

(One row per deletion. If none, write `None.`)

## Final Recommendation

<One paragraph: how to bring branch hygiene to GREEN, expected outcome, follow-up audit cadence.>
