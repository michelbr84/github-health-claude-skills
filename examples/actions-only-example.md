# Example — Actions-Only Audit (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository.

# GitHub Health Report

Repository: michelbr84/fluxswap-dex
Date: 2026-05-05
Mode: actions
Overall Status: YELLOW
Health Score: 72 / 100 (Actions sub-score: 11 / 15)

## Executive Summary

CI on `main` is currently green and most workflows are well-structured, but two findings deserve attention this week: one workflow does not declare a `permissions:` block, and one third-party action is referenced by a floating major. Failure rate across all workflows is 4.2% over the last 30 days — within tolerance — with one job (`integration`) showing flake hints on identical SHAs.

## Blockers

None.

## Attention Needed

- [HIGH] `nightly.yml` does not declare a `permissions:` block.
  Evidence: file `.github/workflows/nightly.yml` has no top-level `permissions:` and no per-job declarations.
  Impact: `GITHUB_TOKEN` defaults to broad permissions for the workflow.
  Recommendation: Add explicit `permissions: { contents: read }` at the top, escalating per-job only where needed.

- [HIGH] `release.yml` references `softprops/action-gh-release@master`.
  Evidence: line 24, action ref `@master`.
  Impact: A future commit on the action's `master` branch could change behavior unexpectedly.
  Recommendation: Pin to a stable tag (e.g., `@v2`) or a SHA.

- [MEDIUM] Job `integration` shows flake hints (3 mixed pass/fail runs on identical SHAs in 30 days).
  Evidence: run IDs 102345, 102780, 103211.
  Impact: PR throughput friction; false reds.
  Recommendation: Investigate test isolation; consider retry strategy with cap.

## Healthy Areas

- All workflows declare names and have intentional triggers.
- `ci.yml` defines `permissions: { contents: read }` at the top and per-job uplifts only where needed.
- Required status checks in branch protection match real workflow jobs.

## Detailed Findings

### Actions

- [INFO] 7 workflows enumerated.
- [HIGH] `nightly.yml` missing `permissions:` block.
- [HIGH] `release.yml` uses `@master` floating ref.
- [MEDIUM] `integration` job flake hints.
- [LOW] `actions/cache@v3` used in `nightly.yml`; v4 available.
- [INFO] Default `GITHUB_TOKEN` repository setting: `read`.

## Recommended Actions

### Do Now

- Add a top-level `permissions: { contents: read }` to `nightly.yml`.
- Replace `softprops/action-gh-release@master` with a stable tag in `release.yml`.

### Do This Week

- Investigate `integration` job flakes; document mitigation.

### Do Later

- Bump `actions/cache@v3` to `@v4`.

## Approval Required Before Destructive Actions

None.

## Final Recommendation

Address the two HIGH workflow findings this week and re-run `/github-health actions https://github.com/michelbr84/fluxswap-dex`. If clear, escalate to `/github-health full <repo>` to confirm the broader picture.
