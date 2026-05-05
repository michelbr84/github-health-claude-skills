# Release Readiness Report

Repository: <owner>/<repo>
Target version / branch: <version or branch>
Date: YYYY-MM-DD
Mode: release-readiness
Overall Status: GREEN / YELLOW / RED
Release Recommendation: READY / NOT YET / DO NOT RELEASE

## Executive Summary

<3–5 sentences: is this repository ready to cut a release today? What's blocking?>

## Snapshot

- Default branch CI: <green/red>
- Open security alerts: <by category and severity>
- Open critical Dependabot alerts: <n>
- Open secret scanning alerts: <n> (any open count blocks release)
- Open malware alerts: <n> (any open count blocks release)
- `CHANGELOG.md` aligned with planned version: <Y/N>
- `README.md` reflects new behavior: <Y/N>
- `SECURITY.md` present and current: <Y/N>
- Open BLOCKER PRs that should land first: <n>
- Stale draft releases: <n>

## Blockers

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### CI

| Workflow | Latest status | Notes |
| --- | --- | --- |
| <file> | <…> | <…> |

### Security

| Category | Open critical | Open high | Notes |
| --- | --- | --- | --- |
| Code scanning | <n> | <n> | <…> |
| Dependabot | <n> | <n> | <…> |
| Secret scanning | <n> | — | Any open is BLOCKER |
| Malware (Dependabot) | <n> | — | Any open is BLOCKER |

### Documentation

| File | Aligned to release? | Notes |
| --- | --- | --- |
| `CHANGELOG.md` | <Y/N> | <…> |
| `README.md` | <Y/N> | <…> |
| `SECURITY.md` | <Y/N> | <…> |

### Outstanding work

| Item | Type | Status | Should block release? |
| --- | --- | --- | --- |
| <PR #n / Issue #n / Linear ID> | <…> | <…> | <Y/N> |

### Versioning

- Last release tag: `<tag>` on <date>.
- Proposed version: `<version>`.
- SemVer rationale: <patch / minor / major because …>.

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

(Creating a release/tag is a state change. Listed here even when READY.)

- Action: Create release `<version>` from `<branch / sha>`.
  Why: All required signals green; CHANGELOG aligned.
  Rollback: Delete the release draft and tag from the GitHub UI; this does not retract artifacts already downloaded.

(Do not include a release action here if Release Recommendation is anything other than READY.)

## Final Recommendation

<One paragraph: explicit RELEASE / WAIT / DO NOT RELEASE, the next concrete step, and whether to re-run a follow-up audit after release.>
