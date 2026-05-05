# Example — Branch Cleanup (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository.

# Branch Cleanup Report

Repository: michelbr84/fluxswap-dex
Date: 2026-05-05
Mode: branches
Overall Status: YELLOW
Health Score: 72 / 100 (branches sub-score: 7 / 10)

## Executive Summary

Branch hygiene is acceptable but needs a tidy-up. Four merged branches remain undeleted and two feature branches are stale without open PRs. Each deletion requires explicit approval and includes a rollback note.

## Snapshot

- Total branches: 22
- Active: 11
- Merged-undeleted: 4
- Stale (>= 60 days, no PR): 2
- Orphan: 1
- Long-lived feature: 0

## Blockers

None.

## Attention Needed

- [MEDIUM] 4 merged branches not yet deleted.
- [LOW] 2 stale feature branches without open PRs.
- [LOW] 1 orphan branch with diverged commits.

## Detailed Findings

### Active branches (sample)

| Branch | Last activity | Author | Open PR | Notes |
| --- | --- | --- | --- | --- |
| `feature/voxel-streaming` | 2026-05-04 | dev1 | #198 | Draft, in progress |
| `feature/loader-refactor` | 2026-05-03 | dev2 | #195 | Ready, awaiting review |

### Merged-undeleted branches

| Branch | Merged on | Into | Recommendation | Rollback |
| --- | --- | --- | --- | --- |
| `feature/heightmap` | 2026-03-12 | `main` | Candidate for deletion | reflog within retention; parent SHA |
| `feature/loader` | 2026-02-28 | `main` | Candidate for deletion | reflog; parent SHA |
| `chore/lints` | 2026-02-22 | `main` | Candidate for deletion | reflog; parent SHA |
| `fix/quat` | 2026-02-15 | `main` | Candidate for deletion | reflog; parent SHA |

### Stale branches

| Branch | Last activity | Open PR | Recommendation |
| --- | --- | --- | --- |
| `wip/audio-prototype` | 2026-02-09 | none | Verify with author before deletion |
| `tmp/perf-bench` | 2026-01-31 | none | Verify with author before deletion |

### Orphan branches

| Branch | Last activity | Ahead of default | Recommendation |
| --- | --- | --- | --- |
| `experiment/ecs-redesign` | 2026-01-04 | 27 commits | Tag `archive/experiment-ecs-redesign` then approve deletion |

### Naming risks

| Branch | Pattern | Risk |
| --- | --- | --- |
| (none detected) | — | — |

## Recommended Actions

### Do Now

- Confirm with branch authors that `wip/audio-prototype` and `tmp/perf-bench` are safe to remove.

### Do This Week

- Create `archive/experiment-ecs-redesign` tag before deletion.

### Do Later

- Adopt a naming convention pre-commit hook (`feat/`, `fix/`, `chore/`, `docs/`).

## Approval Required Before Destructive Actions

- Action: Delete remote branch `feature/heightmap`.
  Target: `origin/feature/heightmap`.
  Why: Merged into `main` 2026-03-12; no downstream references.
  Rollback: `git reflog`; or restore from parent SHA of the merge commit.

- Action: Delete remote branch `feature/loader`.
  Target: `origin/feature/loader`.
  Why: Merged into `main` 2026-02-28; no downstream references.
  Rollback: `git reflog`; parent SHA.

- Action: Delete remote branch `chore/lints`.
  Target: `origin/chore/lints`.
  Why: Merged into `main` 2026-02-22; no downstream references.
  Rollback: `git reflog`; parent SHA.

- Action: Delete remote branch `fix/quat`.
  Target: `origin/fix/quat`.
  Why: Merged into `main` 2026-02-15; no downstream references.
  Rollback: `git reflog`; parent SHA.

- Action: Delete remote branch `experiment/ecs-redesign`.
  Target: `origin/experiment/ecs-redesign`.
  Why: 27 commits ahead, no PR, no activity since 2026-01-04.
  Rollback: Recover from `archive/experiment-ecs-redesign` tag (create first).

(Each item is approvable independently. Do not bundle approvals.)

## Final Recommendation

Approve the four merged-branch deletions today. Defer `experiment/ecs-redesign` until the archive tag is created. Re-run `/github-health branches https://github.com/michelbr84/fluxswap-dex` after to confirm hygiene.
