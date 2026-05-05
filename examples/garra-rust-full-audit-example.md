# Example — Full Audit (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository. Names and numbers were chosen to demonstrate the report structure and the safety guarantees.

# GitHub Health Report

Repository: michelbr84/GarraRUST
Date: 2026-05-05
Mode: full
Overall Status: YELLOW
Health Score: 72 / 100

## Executive Summary

The repository is healthy on most axes but cannot be GREEN today: branch protection on the default branch is missing, and one high-severity CodeQL alert is open without a tracked remediation. CI on `main` is currently green, the documentation set is mostly complete, and Linear is aligned with merged work. The single highest-leverage next action is to enable branch protection on `main` with required reviews and required status checks.

## Blockers

None.

## Attention Needed

- [HIGH] Branch protection missing on `main`.
  Evidence: `gh api repos/.../branches/main` returns `"protected": false`.
  Impact: Direct pushes to default branch possible; required checks cannot be enforced.
  Recommendation: Enable a ruleset that requires PRs, reviews, and status checks before merge.

- [HIGH] CodeQL alert #42 (high severity) open and untriaged.
  Evidence: `gh api repos/.../code-scanning/alerts?state=open` includes alert 42 (rule `rust/uninitialized-local`, file `src/engine/world.rs:212`).
  Impact: Potential undefined behavior in a hot path.
  Recommendation: Track in an issue or Linear ticket and assign for remediation.

- [MEDIUM] 6 stale Dependabot PRs.
  Evidence: 6 PRs opened by `app/dependabot` with no activity > 14 days.
  Impact: Drift accumulates; security updates are delayed.
  Recommendation: Triage each; merge if checks pass and the change is acceptable.

- [MEDIUM] `CHANGELOG.md` two releases behind the latest tag.
  Evidence: Latest release `v0.4.2` (2026-04-12); CHANGELOG ends at `v0.4.0`.
  Impact: Users cannot see what changed without reading commits.
  Recommendation: Backfill `[0.4.1]` and `[0.4.2]` sections.

## Healthy Areas

- Default branch CI green; failure rate < 5% over the last 30 days.
- `SECURITY.md` present and current with private vulnerability reporting enabled.
- Workflows pin actions by stable major and declare `permissions:` blocks.
- 0 open secret scanning alerts; 0 malware alerts.
- Linear scope `GARRA` shows healthy alignment with merged PRs.

## Detailed Findings

### Main Branch

- [HIGH] Default branch `main` is not protected.
  Evidence: protection `false`.
  Impact: Any collaborator with `write` could push directly.
  Recommendation: Apply ruleset requiring PR + 1 review + status checks.

### Actions

- [INFO] 7 workflows enumerated (`ci.yml`, `release.yml`, `lint.yml`, `audit.yml`, `coverage.yml`, `docs.yml`, `nightly.yml`).
- [LOW] `nightly.yml` uses `actions/cache@v3` (still supported but newer major exists).
  Recommendation: Bump to `@v4` in a routine update PR.

### Pull Requests

- [MEDIUM] 6 stale Dependabot PRs (see Attention Needed).
- [MEDIUM] PR #198 mergeable but `coverage` check pending — **do not merge yet**.
  Evidence: `mergeable: clean`, but `coverage` status `pending`.
  Recommendation: Wait for `coverage` to complete; do not bypass.

### Branches

- [LOW] 4 merged branches not yet deleted.
- [LOW] 2 stale feature branches (>60 days) without open PRs.

### Issues

- [LOW] 14 open issues; 3 missing labels.
- [INFO] Backlog growth slightly outpaces closure over the audit window.

### Security

- [HIGH] CodeQL alert #42 open (see Attention Needed).
- [INFO] Push protection enabled.
- [INFO] `SECURITY.md` includes private reporting channel.

### Dependencies

- [MEDIUM] 6 stale Dependabot PRs (mirrored under PRs).
- [INFO] Lockfile `Cargo.lock` present and aligned with `Cargo.toml`.
- [INFO] No abandoned critical dependencies detected.

### Documentation

- [MEDIUM] `CHANGELOG.md` behind by two releases.
- [INFO] `README.md` install section verified against current commands.
- [INFO] `CONTRIBUTING.md` and `CODEOWNERS` present.

### Releases

- [INFO] Latest release `v0.4.2` on 2026-04-12; tag and release aligned.
- [LOW] `v0.4.1` release notes are sparse; consider expanding.

### Linear / Roadmap Sync

- [INFO] `ROADMAP.md` aligned with Linear project `GARRA Q2`.
- [LOW] PR #195 lacks a Linear linkage; recommend tagging.

## Recommended Actions

### Do Now

- Open an issue (or Linear ticket) tracking remediation for CodeQL alert #42.
- Triage the 6 stale Dependabot PRs.

### Do This Week

- Enable branch protection on `main` with required reviews and required status checks.
- Backfill `CHANGELOG.md` for `0.4.1` and `0.4.2`.
- Link PR #195 to a Linear issue.

### Do Later

- Bump `actions/cache@v3` → `@v4` in `nightly.yml`.
- Expand `v0.4.1` release notes.

## Approval Required Before Destructive Actions

- Action: Delete merged-and-undeleted remote branches `feature/heightmap`, `feature/loader`, `chore/lints`, `fix/quat`.
  Target: `origin/<each>`.
  Why: All merged into `main` > 30 days ago; no downstream references found.
  Rollback: Restore via `git reflog` within retention window or from each branch's parent SHA; consider creating `archive/<name>` tags first.

- Action: Close stale draft PR #176.
  Target: PR `#176`.
  Why: No activity 95 days; author inactive 60+ days.
  Rollback: Re-open from the PR view within 30 days.

## Final Recommendation

Enable branch protection on `main` and assign owner remediation for CodeQL alert #42 today. After both land, re-run `/github-health full https://github.com/michelbr84/GarraRUST` to confirm the status moves from YELLOW to GREEN.
