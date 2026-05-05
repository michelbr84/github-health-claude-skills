# Linear Sync Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: linear
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100 (Linear/Roadmap sub-score: <0-10>)

## Source of truth

- GitHub = technical source of truth.
- Linear = operational source of truth.
- When the two disagree, this report names the disagreement and recommends one direction.

## Executive Summary

<3–5 sentences on the state of GitHub ↔ Linear sync and the single most important next action.>

## Snapshot

- Linear scope inspected: <team / project / cycle>
- PRs in window: <n>
- PRs linked to Linear: <n>
- PRs unlinked: <n>
- Linear In-Progress without GitHub evidence: <n>
- Linear Done without merged PR: <n>
- Merged PRs missing Linear status update: <n>
- Roadmap drift items: <n>
- Auto-close risks: <n>

## Blockers

(If none, write `None.`)

## Attention Needed

- [HIGH] <…>
- [MEDIUM] <…>

## Detailed Findings

### PRs without Linear

| PR | Title | Branch | Recommendation |
| --- | --- | --- | --- |
| #<n> | <title> | `<branch>` | Link to Linear issue or document why no link is needed |

### Linear In-Progress without GitHub evidence

| Linear ID | Title | Status | Last update | Recommendation |
| --- | --- | --- | --- | --- |
| `<ID>` | <title> | In Progress | <date> | Move back to backlog or open a draft PR |

### Linear Done without merged PR

| Linear ID | Title | Status | Recommendation |
| --- | --- | --- | --- |
| `<ID>` | <title> | Done | Verify merged PR or move back to In Review |

### Merged PRs missing Linear status update

| PR | Linear ID | PR merged on | Linear status | Recommended status |
| --- | --- | --- | --- | --- |
| #<n> | `<ID>` | <date> | <status> | Done |

### Roadmap drift

| `ROADMAP.md` item | Linear scope | Status | Recommendation |
| --- | --- | --- | --- |
| <line> | <project/initiative or none> | <…> | Add Linear scope or remove from roadmap |

### Auto-close risks

| PR / branch | Pattern | Risk | Recommendation |
| --- | --- | --- | --- |
| #<n> / `<branch>` | `Closes <ID>` | Could auto-close on merge | Edit title; do not pre-close |

## Recommended Actions

### Do Now

- <Imperative, non-destructive.>

### Do This Week

- <Imperative.>

### Do Later

- <Imperative.>

## Approval Required Before Destructive Actions

(Any update to a Linear issue or any GitHub edit driven by Linear is gated here.)

- Action: Update Linear `<ID>` from `<old-status>` to `<new-status>`.
  Why: PR `#<n>` merged on <date>, evidence of completion.
  Rollback: Re-set Linear `<ID>` back to `<old-status>` from the Linear UI.

(If none, write `None.`)

## Final Recommendation

<One paragraph: how to bring GitHub ↔ Linear back into alignment, expected outcome, and follow-up cadence.>
