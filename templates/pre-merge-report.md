# Pre-Merge Report

Repository: <owner>/<repo>
PR: #<number> — <title>
Date: YYYY-MM-DD
Mode: pre-merge
Overall Status: GREEN / YELLOW / RED
Merge Recommendation: SAFE / NOT YET / DO NOT MERGE

## Executive Summary

<3–5 sentences: should this PR be merged now? What's blocking? What's required next?>

## Snapshot

- Mergeable state: <clean / dirty / blocked / unknown>
- Required check status: <success / failure / pending / missing>
- Review decision: <approved / changes_requested / review_required>
- Conflicts: <yes / no>
- Linked issue or Linear ticket: <link / none>
- Auto-close risk in title or body: <yes / no>
- Branch base: <default / non-default>

## Blockers

(Listed with [BLOCKER] severity. If any required check is `pending`, this section MUST list it. If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### Required checks

| Check | State | Run URL/ID | Notes |
| --- | --- | --- | --- |
| <name> | <state> | <id> | <notes> |

### Reviews

| Reviewer | Decision | Last activity |
| --- | --- | --- |
| <handle> | <approved / changes_requested / commented / pending> | <date> |

### Conflicts

- <Files / paths in conflict, if any.>

### Traceability

| Source | Reference | OK |
| --- | --- | --- |
| Linked issue | #<n> or none | <Y/N> |
| Linked Linear | `<ID>` or none | <Y/N> |
| Auto-close substring | <found / not found> | <Y/N — Y means risk> |

### Quick CI signal

- Default branch CI: <green/red>
- This PR's HEAD CI: <green/red/pending>

## Recommended Actions

### Do Now

- <Imperative, non-destructive — e.g., "Wait for `lint` check to complete (in progress).">

### Do This Week

- <Imperative.>

## Approval Required Before Destructive Actions

(Merge is itself a state change. Listed here even when SAFE, with the user's explicit approval required.)

- Action: Merge PR `#<n>` via <merge / squash / rebase>.
  Target: PR `#<n>` into `<base>`.
  Why: All required checks green, reviews satisfied, no auto-close risk.
  Rollback: Revert via `git revert <merge-sha>` and open a follow-up PR.

(Do not include a merge action in this section if Merge Recommendation is anything other than SAFE.)

## Final Recommendation

<One paragraph: explicit `MERGE` / `WAIT` / `DO NOT MERGE` recommendation, with the next concrete step. If WAIT, name the exact signal to wait for.>
