---
name: github-health-cleanup-plan
description: "Produce a safe, approval-gated multi-area cleanup plan for a GitHub repository covering branches, stale PRs, stale issues, documentation updates, security follow-ups, and Linear synchronization. Use this for cross-cutting cleanup; for branches-only cleanup use github-health-branches. Triggers on `/github-health cleanup-plan <repo>` and requests like \"give me a cleanup plan\" or \"what should I tidy up across the repo\". Read-only; every destructive step is explicitly approval-gated."
---

# github-health-cleanup-plan

## When to trigger

- `/github-health cleanup-plan <repo>`
- Requests for a "tidy-up plan", "cleanup script", or "what should I delete".

## Required inputs

- GitHub repository URL.
- Optional: which areas to include (default: all of branches, PRs, issues, docs, security follow-ups, Linear).

## Reference files

- `github-health/references/github-health-checklist.md`
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`
- `templates/remediation-plan.md`

## Procedure

1. Run a lightweight audit across the requested areas, reusing the relevant specialized skills' procedures.
2. Build a **Cleanup Plan** with the following groups, ordered by safety:
   1. **Read-only verification** — commands the user should run to confirm state.
   2. **Non-destructive improvements** — doc updates, label additions, milestone fixes, README polish, CONTRIBUTING additions.
   3. **Approval-gated destructive cleanup** — branch deletions, PR closures, issue closures, alert dismissals, release deletions.
3. For each destructive item, include:
   - The exact action.
   - The exact target (branch name, PR number, issue number, alert ID, etc.).
   - Why it is safe to proceed (evidence).
   - The rollback or recovery path.
   - The approval required from the user.
4. Score per `scoring-model.md` if a top-level status is requested.
5. Render the report.

## Evidence to collect

Reuse the evidence from:

- `github-health-branches`
- `github-health-pulls`
- `github-health-issues`
- `github-health-docs`
- `github-health-releases`
- `github-health-linear`
- `github-health-security` (only when security follow-ups are part of the cleanup)

## Red flags

- [BLOCKER] A destructive recommendation has been made without explicit approval being available — must move to the Approval block.
- [HIGH] Cleanup proposed for items that are referenced by a release, deployment, or downstream fork.
- [HIGH] Cleanup proposed for branches with open PRs.
- [MEDIUM] Cleanup affects items modified in the last 7 days.

## Output format

Use the standard contract, with **Detailed Findings** populated only for the included areas.

In the **Recommended Actions** section, structure each item as:

```
- [Severity] Title.
  Target: <branch / PR / issue / alert / file>.
  Evidence: <why this is a candidate for cleanup>.
  Risk: <what could go wrong>.
  Recovery: <how to undo>.
  Approval needed: yes/no.
```

All `Approval needed: yes` items are duplicated under **Approval Required Before Destructive Actions** so the user has one consolidated review block.

## Safety rules

- **Never execute any destructive step.** This skill produces a plan only.
- Each destructive recommendation must be evaluated individually with evidence; no blanket "delete all merged branches" recommendations without per-branch evidence.
- For each branch deletion, include a recovery note pointing to `git reflog`, the merge commit's parent, or a backup tag the user can create first (and recommending creating that backup tag before deletion).
- Encourage the user to run a backup workflow first (e.g., `git fetch && git tag -a archive/<branch> origin/<branch>`) before deletions.
- Never propose force-pushes, history rewrites, or rulesets changes as part of cleanup.

## When to escalate

- If cleanup recommendations are too broad to fit one report, recommend a follow-up `/github-health full <repo>` for context, then a focused cleanup-plan run on a narrowed scope.
- If security follow-ups dominate the cleanup, escalate to `github-health-security`.

## What not to do

- Do not bundle cleanup steps into a single approval. Each destructive step must be approvable independently.
- Do not propose deleting items merely because they are old. Old is not a synonym for unsafe.
- Do not auto-resolve Linear issues as part of a "GitHub cleanup".
