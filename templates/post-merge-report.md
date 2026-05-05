# Post-Merge Report

Repository: <owner>/<repo>
PR: #<number> — <title>
Merged on: YYYY-MM-DD
Mode: post-merge
Overall Status: GREEN / YELLOW / RED

## Executive Summary

<3–5 sentences: did the merge land cleanly? Any follow-up needed? What's the single highest-value next action?>

## Snapshot

- Default branch CI after merge: <green/red/pending>
- Merge SHA: <sha>
- Source branch state: <still present / deleted>
- Linear ticket update: <updated / pending / N/A>
- CHANGELOG / docs touched if needed: <yes / no / N/A>
- Releases triggered: <yes / no / N/A>

## Blockers

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### CI after merge

| Workflow | Status | Run URL/ID | Notes |
| --- | --- | --- | --- |
| <file> | <green/red/pending> | <id> | <notes> |

### Source branch

| Branch | State | Recommendation | Rollback |
| --- | --- | --- | --- |
| `<head>` | merged & present | Candidate for deletion (approval-gated) | reflog / parent SHA |

### Linear update

| Linear ID | Pre-merge status | Current status | Recommendation |
| --- | --- | --- | --- |
| `<ID>` | <…> | <…> | Move to Done if not already |

### Documentation drift

| File | Touched in PR? | Likely needs update | Recommendation |
| --- | --- | --- | --- |
| `CHANGELOG.md` | <Y/N> | <Y/N> | Add entry under `[Unreleased]` |
| `README.md` | <Y/N> | <Y/N> | Update commands / paths if changed |

### Release follow-up

- <Whether this PR should be part of the next release; whether `CHANGELOG.md` is updated; whether a tag is now warranted.>

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

- Action: Delete source branch `<head>`.
  Target: `origin/<head>`.
  Why: Merged on <date> via PR `#<n>`; no downstream references.
  Rollback: Restore via reflog or parent SHA; or restore via the GitHub UI.

(One row per destructive proposal. If none, write `None.`)

## Final Recommendation

<One paragraph: the single most important follow-up, expected outcome, and whether to run `/github-health release-readiness <repo>` next.>
