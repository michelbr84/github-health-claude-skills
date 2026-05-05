---
name: github-health-linear
description: Audit synchronization between GitHub and Linear — PR/ticket alignment, status drift, roadmap drift, security follow-ups, and auto-close risks. Treats GitHub as the technical source of truth and Linear as the operational source of truth. Triggers on /github-health linear <repo> and on requests about Linear sync, roadmap drift, or PR/ticket traceability. Read-only; never modifies Linear records.
---

# github-health-linear

## When to trigger

- `/github-health linear <repo>`
- Questions about Linear ↔ GitHub sync, roadmap drift, missing tickets, or "is this Linear ticket really done".

## Required inputs

- GitHub repository URL.
- Optional: Linear team / project / cycle scope.

## Source of truth

- **GitHub** = technical source of truth (code, PRs, branches, CI, security alerts).
- **Linear** = operational source of truth (priorities, statuses, cycles, milestones, owners).

When the two disagree, the report should describe the disagreement, recommend a single source-of-truth update, and surface any state-changing recommendation under **Approval Required Before Destructive Actions**.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 14.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Detect Linear availability. If no Linear access is present, mark the section `Not applicable` and explain why.
2. Build two cross-reference views:
   - **PR → Linear**: every open and recently merged PR matched (or not) to a Linear issue.
   - **Linear → GitHub**: every Linear issue in the relevant scope matched (or not) to PR/branch/commit evidence.
3. Detect:
   - PRs without a linked Linear issue.
   - PRs whose linked Linear issue is in a state that does not match the PR state.
   - Linear issues marked **In Progress** without an active branch or open PR.
   - Linear issues marked **Done** without a merged PR.
   - Merged PRs whose Linear issue was not updated to **Done**.
   - Branch names or PR titles that contain `Closes <LINEAR-ID>` or `Fixes <LINEAR-ID>` and could trigger auto-close on merge.
4. Compare `ROADMAP.md` to Linear initiatives, projects, cycles, or epics. Flag drift.
5. Identify any GitHub security follow-up that should be tracked in a private Linear project rather than a public issue.
6. Score the Linear / Roadmap Sync area (weight 10) per `scoring-model.md`.
7. Render a report focused on **Linear / Roadmap Sync**.

## Evidence to collect

- GitHub: PRs, branches, merged commits in the relevant window.
- Linear (read-only): issues, statuses, projects, cycles, milestones.
- `ROADMAP.md` content.

Match keys:

- Linear issue ID pattern (e.g., `[A-Z]{2,8}-\d+`) inside PR title, body, branch name, or commit message.
- PR URL referenced inside the Linear issue or its comments.

## Red flags

- [HIGH] Linear issue `Done` without merged PR evidence.
- [HIGH] `ROADMAP.md` lists items that no Linear initiative covers (or vice versa).
- [HIGH] Branch name or PR title would auto-close a Linear issue but the work is incomplete.
- [MEDIUM] Linear `In Progress` issue with no branch or PR.
- [MEDIUM] Merged PR whose Linear issue is still `In Review` or earlier.
- [MEDIUM] Many PRs without Linear linkage on a Linear-driven project.
- [LOW] Linear issue title and PR title diverge significantly (loss of context).

## Output format

Use the standard contract. Populate **Detailed Findings → Linear / Roadmap Sync** in depth, with sub-tables:

1. **PRs without Linear** — PR number, title, branch, recommendation.
2. **Linear In Progress without GitHub evidence** — issue ID, title, status, last update, recommendation.
3. **Linear Done without merged PR** — issue ID, title, recommended verification.
4. **Merged PRs missing Linear status update** — PR number, Linear issue ID, recommended status change.
5. **Roadmap drift** — `ROADMAP.md` items vs Linear scope.
6. **Auto-close risks** — PR / branch text that may close Linear issues unintentionally.

## Safety rules

- **Never modify any Linear record.** No status changes, no comments, no edits.
- Recommendations to update Linear status, link a PR, or close an issue go under **Approval Required Before Destructive Actions**.
- For private security work, recommend a private Linear project — do not create or modify it.
- Never paste Linear issue descriptions verbatim into a public report when they may contain sensitive context.

## When to escalate

- If many security follow-ups are tracked in public GitHub issues, escalate to `github-health-security` and recommend moving to private channels.
- If roadmap drift is severe, recommend `/github-health full <repo>` to align with documentation, releases, and CI signals.

## What not to do

- Do not silently treat Linear as ground truth and overwrite GitHub assumptions, or vice versa. Report both, recommend one direction.
- Do not merge a PR to "make Linear consistent" — never merge in this skill.
- Do not include personal Linear notes that may be private.
