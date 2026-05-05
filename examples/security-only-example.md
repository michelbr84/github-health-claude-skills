# Example — Security-Only Audit (Illustrative)

> **This example is illustrative only.** It does **not** reflect live data from any real repository.

# GitHub Health Report

Repository: michelbr84/fluxswap-dex
Date: 2026-05-05
Mode: security
Overall Status: YELLOW
Health Score: 72 / 100 (Security sub-score: 16 / 20)

## Executive Summary

The repository's security posture is mostly solid: secret scanning, push protection, and code scanning are enabled, and `SECURITY.md` is current. The status cannot be GREEN today because one high-severity CodeQL alert remains untriaged. There are no open secret scanning, malware, or critical Dependabot alerts.

## Blockers

None.

## Attention Needed

- [HIGH] CodeQL alert #42 (high severity) open and untriaged.
  Evidence: `gh api repos/.../code-scanning/alerts?state=open` shows alert 42, rule `rust/uninitialized-local`, file `src/engine/world.rs:212`.
  Impact: Potential undefined behavior in a hot path; status floor blocks GREEN.
  Recommendation: Open an issue (or Linear ticket) and assign for remediation.

- [MEDIUM] 6 stale Dependabot PRs not yet triaged.
  Evidence: 6 PRs by `app/dependabot` with no activity > 14 days.
  Impact: Security updates are being delayed.
  Recommendation: Review and merge if checks pass and the change is acceptable.

## Healthy Areas

- 0 open secret scanning alerts.
- 0 open malware (Dependabot) alerts.
- 0 open critical Dependabot alerts.
- Push protection enabled.
- Private vulnerability reporting enabled.
- `SECURITY.md` includes a clear reporting channel and disclosure policy.

## Detailed Findings

### Security

#### Settings snapshot

- Code scanning: enabled (CodeQL, Rust queries).
- Secret scanning: enabled.
- Push protection: enabled.
- Private vulnerability reporting: enabled.
- Dependabot version updates: enabled.
- Dependabot security updates: enabled.

#### Open alerts

| Category | Critical | High | Medium | Low |
| --- | --- | --- | --- | --- |
| Code scanning | 0 | 1 | 0 | 0 |
| Dependabot | 0 | 0 | 4 | 7 |
| Secret scanning | 0 | — | — | — |
| Malware (Dependabot) | 0 | — | — | — |

#### Code scanning detail

| Alert ID | Rule | Severity | Location | State | Recommendation |
| --- | --- | --- | --- | --- | --- |
| 42 | `rust/uninitialized-local` | High | `src/engine/world.rs:212` | open | Track remediation; assign owner |

#### Workflow permissions

| Workflow | Default `GITHUB_TOKEN` | `permissions:` declared? | Notes |
| --- | --- | --- | --- |
| `ci.yml` | read | yes | Per-job uplifts |
| `release.yml` | read | yes | Uses pinned actions |
| `nightly.yml` | read | **no** | Add explicit block |
| `audit.yml` | read | yes | — |

## Recommended Actions

### Do Now

- Open an issue or Linear ticket for CodeQL alert #42.
- Triage the 6 stale Dependabot PRs.

### Do This Week

- Add `permissions:` block to `nightly.yml`.

### Do Later

- Re-audit after CodeQL alert #42 is resolved.

## Approval Required Before Destructive Actions

None — all recommendations above are non-destructive.

## Final Recommendation

Address CodeQL alert #42 and triage the Dependabot PR backlog. Once both are clear, re-run `/github-health security https://github.com/michelbr84/fluxswap-dex` to confirm the security score moves toward GREEN.
