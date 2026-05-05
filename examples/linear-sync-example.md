# Example — Linear Sync (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository or Linear workspace.

# Linear Sync Report

Repository: michelbr84/GarraRUST
Date: 2026-05-05
Mode: linear
Overall Status: YELLOW
Health Score: 72 / 100 (Linear/Roadmap sub-score: 6 / 10)

## Source of truth

- GitHub = technical source of truth.
- Linear = operational source of truth.

## Executive Summary

GitHub and Linear are mostly aligned, but there are three notable gaps: one PR has no Linear linkage, one Linear issue is `Done` without merged PR evidence, and one merged PR's Linear issue still shows `In Review`. No auto-close risks were detected.

## Snapshot

- Linear scope inspected: project `GARRA Q2`, cycle `2026-05`
- PRs in window: 14
- PRs linked to Linear: 13
- PRs unlinked: 1
- Linear In-Progress without GitHub evidence: 0
- Linear Done without merged PR: 1
- Merged PRs missing Linear status update: 1
- Roadmap drift items: 0
- Auto-close risks: 0

## Blockers

None.

## Attention Needed

- [HIGH] Linear `GARRA-104` marked Done without merged PR evidence.
- [MEDIUM] Merged PR #194 not reflected in Linear `GARRA-99` status.
- [MEDIUM] PR #195 lacks any Linear linkage.

## Detailed Findings

### PRs without Linear

| PR | Title | Branch | Recommendation |
| --- | --- | --- | --- |
| #195 | "Refactor loader for streaming" | `feature/loader-refactor` | Add Linear ID to PR body or branch name |

### Linear In-Progress without GitHub evidence

| Linear ID | Title | Status | Last update | Recommendation |
| --- | --- | --- | --- | --- |
| (none) | — | — | — | — |

### Linear Done without merged PR

| Linear ID | Title | Status | Recommendation |
| --- | --- | --- | --- |
| `GARRA-104` | "Cinemachine playmode capture" | Done | Verify completion or move back to In Review (approval-gated) |

### Merged PRs missing Linear status update

| PR | Linear ID | PR merged on | Linear status | Recommended status |
| --- | --- | --- | --- | --- |
| #194 | `GARRA-99` | 2026-05-02 | In Review | Done (approval-gated) |

### Roadmap drift

| `ROADMAP.md` item | Linear scope | Status | Recommendation |
| --- | --- | --- | --- |
| (none — `ROADMAP.md` aligned with `GARRA Q2`) | — | — | — |

### Auto-close risks

| PR / branch | Pattern | Risk | Recommendation |
| --- | --- | --- | --- |
| (none detected) | — | — | — |

## Recommended Actions

### Do Now

- Add `GARRA-<id>` to PR #195 (description or title).

### Do This Week

- Verify `GARRA-104` is genuinely complete; if not, move back to `In Review` with approval.
- Update `GARRA-99` to `Done` in Linear with approval, since PR #194 merged on 2026-05-02.

### Do Later

- Add a CONTRIBUTING note instructing every PR to reference its Linear ID.

## Approval Required Before Destructive Actions

- Action: Update Linear `GARRA-99` from `In Review` to `Done`.
  Why: PR #194 merged on 2026-05-02; CHANGELOG references the work.
  Rollback: Move back to `In Review` from the Linear UI.

- Action: Move Linear `GARRA-104` from `Done` back to `In Review`.
  Why: No merged PR evidence; the issue may have been closed prematurely.
  Rollback: Move back to `Done` from the Linear UI.

(Each item is approvable independently.)

## Final Recommendation

Reconcile `GARRA-99` and `GARRA-104` this week and add Linear linkage to PR #195. Then re-run `/github-health linear https://github.com/michelbr84/GarraRUST` to confirm sync is clean.
