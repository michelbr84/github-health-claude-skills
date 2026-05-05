# Example — Post-Merge (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository.

# Post-Merge Report

Repository: michelbr84/fluxswap-dex
PR: #194 — "Refactor camera capture pipeline"
Merged on: 2026-05-02
Mode: post-merge
Overall Status: YELLOW

## Executive Summary

The merge landed cleanly — default branch CI is green. Two follow-ups are open: the source branch is still present (candidate for deletion), and the linked Linear issue `<linear-id>` was not moved from `In Review` to `Done`. No regressions detected so far.

## Snapshot

- Default branch CI after merge: green
- Merge SHA: `9f3a2b7`
- Source branch state: still present (`feature/camera-capture`)
- Linear ticket update: pending (`<linear-id>` still In Review)
- CHANGELOG / docs touched if needed: yes (added `[Unreleased]` entry)
- Releases triggered: no

## Blockers

None.

## Attention Needed

- [MEDIUM] Linear `<linear-id>` not moved to `Done`.
- [LOW] Source branch `feature/camera-capture` still present.

## Detailed Findings

### CI after merge

| Workflow | Status | Run URL/ID | Notes |
| --- | --- | --- | --- |
| `ci.yml` | success | run-219955 | — |
| `lint.yml` | success | run-219956 | — |
| `coverage.yml` | success | run-219957 | Slight increase in coverage |

### Source branch

| Branch | State | Recommendation | Rollback |
| --- | --- | --- | --- |
| `feature/camera-capture` | merged & present | Candidate for deletion (approval-gated) | reflog / parent SHA |

### Linear update

| Linear ID | Pre-merge status | Current status | Recommendation |
| --- | --- | --- | --- |
| `<linear-id>` | In Review | In Review | Move to Done with approval |

### Documentation drift

| File | Touched in PR? | Likely needs update | Recommendation |
| --- | --- | --- | --- |
| `CHANGELOG.md` | yes | no | Already updated under `[Unreleased]` |
| `README.md` | no | no | — |

### Release follow-up

- No release triggered. PR #194 will be part of the next minor release per SemVer rationale.

## Recommended Actions

### Do Now

- Approve Linear status change for `<linear-id>` to `Done`.

### Do This Week

- Approve deletion of source branch `feature/camera-capture` (after final confirmation).

### Do Later

- Consider running `/github-health release-readiness <repo>` when accumulated changes warrant a minor release.

## Approval Required Before Destructive Actions

- Action: Update Linear `<linear-id>` from `In Review` to `Done`.
  Why: PR #194 merged 2026-05-02; CI green; CHANGELOG entry added.
  Rollback: Move back to `In Review` from the Linear UI.

- Action: Delete source branch `feature/camera-capture`.
  Target: `origin/feature/camera-capture`.
  Why: Merged via PR #194; no downstream references found.
  Rollback: Restore via `git reflog` within retention or from parent SHA.

## Final Recommendation

Approve the two pending state changes and consider running `/github-health release-readiness https://github.com/michelbr84/fluxswap-dex` when ready to cut the next minor.
