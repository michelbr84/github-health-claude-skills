# Remediation Plan

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Source audit: <full / actions / branches / pulls / issues / security / linear / cleanup-plan / pre-merge / post-merge / release-readiness>
Overall Status: GREEN / YELLOW / RED

## Goals

- <One short goal per line — e.g., "clear all BLOCKERs", "bring CI to consistent green", "align Linear with merged PRs".>

## Constraints

- <Time, capacity, or scope constraints stated by the user.>

## Plan

Each item is one row. Items are ordered by safety: read-only verification → non-destructive improvements → approval-gated destructive cleanup.

### 1. Read-only verification

| # | Step | Command / link | Expected output | Owner |
| --- | --- | --- | --- | --- |
| 1.1 | <verify X> | `<command>` | <shape> | <handle / role> |

### 2. Non-destructive improvements

| # | Step | Area | Severity | Owner | Target by |
| --- | --- | --- | --- | --- | --- |
| 2.1 | <update README install section> | docs | LOW | <handle> | <date> |
| 2.2 | <add `permissions:` block to workflow X> | actions | HIGH | <handle> | <date> |

### 3. Approval-gated destructive cleanup

| # | Action | Target | Why | Rollback | Approval needed |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Delete branch | `<branch>` | Merged on <date>, no references | reflog / parent SHA / `archive/<branch>` tag | yes |
| 3.2 | Close PR | `#<n>` | Author inactive 90+ days | Re-open from PR view within 30 days | yes |
| 3.3 | Dismiss alert | `<category>/<id>` | <documented reason> | Re-open from Security tab | yes |

## Sequencing

- Phase 0: complete all `Do Now` items.
- Phase 1: complete `Do This Week`.
- Phase 2: schedule `Do Later`.
- Phase 3: process the **Approval Required Before Destructive Actions** queue with the user, one item at a time.

## Definition of done

- All BLOCKERs resolved.
- Status moved from <current> to <target>.
- Health score moved from <current> to <target>.
- Linear / Roadmap aligned (if applicable).
- Re-audit run: `/github-health <mode> <repo>` and re-attached as evidence.

## Approval queue

- Item 3.1: <approved / pending / declined>
- Item 3.2: <approved / pending / declined>
- Item 3.3: <approved / pending / declined>

(Each item is approvable independently. Bulk approval is not allowed in V1.)
