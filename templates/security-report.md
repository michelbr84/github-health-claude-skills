# Security Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: security
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100 (security sub-score: <0-20>)

## Executive Summary

<3–5 sentences on the current security posture and the single most important next action. Mention any BLOCKER explicitly.>

## Settings snapshot

- Code scanning: <enabled/disabled>
- Secret scanning: <enabled/disabled>
- Push protection: <enabled/disabled>
- Private vulnerability reporting: <enabled/disabled>
- Dependabot version updates: <enabled/disabled>
- Dependabot security updates: <enabled/disabled>
- `SECURITY.md`: <present/missing>
- Branch protection on default: <on/off, with summary>

## Open alerts

| Category | Critical | High | Medium | Low |
| --- | --- | --- | --- | --- |
| Code scanning | <n> | <n> | <n> | <n> |
| Dependabot | <n> | <n> | <n> | <n> |
| Secret scanning | <n> (any open count is a BLOCKER) | — | — | — |
| Malware (Dependabot class) | <n> (any open count is a BLOCKER) | — | — | — |

## Blockers

- [BLOCKER] <Title>. Evidence (alert ID, resource type, file path). Impact. Recommendation.

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### Code scanning

| Alert ID | Rule | Severity | Location | State | Recommendation |
| --- | --- | --- | --- | --- | --- |
| <id> | <rule> | <severity> | <file:line> | <state> | <next step> |

### Dependabot

| Alert ID | Package | Ecosystem | Severity | Fixed version | Recommendation |
| --- | --- | --- | --- | --- | --- |
| <id> | <pkg> | <ecosystem> | <severity> | <version> | <next step> |

### Secret scanning

(Refer by alert ID and resource type only — never the secret value.)

| Alert ID | Resource type | Location reference | State | Recommendation |
| --- | --- | --- | --- | --- |
| <id> | <e.g., aws_access_key_id> | <file path / commit ref> | <open/dismissed> | Rotate via provider console; remove from history manually |

### Workflow permissions

| Workflow | Default `GITHUB_TOKEN` | `permissions:` declared? | Notes |
| --- | --- | --- | --- |
| `<file>` | <read/write> | <yes/no> | <comments> |

### `SECURITY.md`

| Present | Last updated | Reporting channel | Disclosure policy | Notes |
| --- | --- | --- | --- | --- |
| <Y/N> | <date> | <described/missing> | <described/missing> | <notes> |

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

- Action: Dismiss alert `<id>` with reason `<reason>`.
  Target: `<category>/<id>`.
  Why: <one line>.
  Rollback: Reopen via the GitHub Security tab.

(One row per destructive proposal. If none, write `None.`)

## Final Recommendation

<One paragraph: what to do first to clear all BLOCKERs and bring posture to at least YELLOW; whether to re-run `/github-health full <repo>` afterward.>
