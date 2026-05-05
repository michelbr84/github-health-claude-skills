# Actions Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: actions
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100 (Actions sub-score: <0-15>)

## Executive Summary

<3–5 sentences on CI health and the single most useful next action.>

## Snapshot

- Default branch latest CI: <green/red/missing>
- Workflows enumerated: <n>
- Required status checks configured: <n> (matched to jobs: <n>; drifted: <n>)
- Failed runs in last 30 days: <n>
- Flake hints (jobs with mixed pass/fail on same SHA): <n>

## Blockers

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### Workflow inventory

| Workflow | Triggers | `permissions:` block | Failure rate (30d) | Notes |
| --- | --- | --- | --- | --- |
| `<file>` | <list> | <yes/no, scope> | <%> | <notes> |

### Required status checks alignment

| Required check | Matched job | Workflow | Notes |
| --- | --- | --- | --- |
| <name> | <yes/no> | `<file>` | <comments> |

### Action pinning

| Workflow | Action | Pin | Notes |
| --- | --- | --- | --- |
| `<file>` | `<owner>/<repo>` | `<@v4 / @sha / @main>` | <ok / floating / deprecated> |

### Recent failures and flakes

| Workflow | Job | Last failed | Hits in 30d | Likely cause |
| --- | --- | --- | --- | --- |
| `<file>` | `<job>` | <date> | <n> | <description> |

### Secret references

| Workflow | Secret name | Used in step | Echoed? |
| --- | --- | --- | --- |
| `<file>` | `<name>` | `<step>` | <no/yes — flag if yes> |

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

(Anything that would change CI behavior — e.g., disabling a workflow, removing a required check — goes here.)

- Action: <…>.
  Target: <…>.
  Why: <…>.
  Rollback: <…>.

(If none, write `None.`)

## Final Recommendation

<One paragraph: how to stabilize CI, expected outcome, and whether to re-run `/github-health full <repo>` to inspect protections and security alongside.>
