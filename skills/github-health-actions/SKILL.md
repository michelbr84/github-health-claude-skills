---
name: github-health-actions
description: Audit GitHub Actions workflows, recent runs, required status checks, flake hints, action pinning, and workflow permissions. Triggers on /github-health actions <repo> and on requests like "are my Actions healthy", "why is CI flaky", "are workflow permissions least privilege". Read-only; never enables, disables, or runs workflows on its own.
---

# github-health-actions

## When to trigger

- `/github-health actions <repo>`
- Questions about CI health, workflow failures, flakes, permissions, or required checks.

## Required inputs

- GitHub repository URL.
- Optional: a specific workflow name or job name to focus on.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 2.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Enumerate workflows under `.github/workflows/`.
2. List recent runs (last 30) per workflow, capturing status and duration.
3. Identify failed and cancelled runs; group by job.
4. Detect flake hints: a job that has both passed and failed on the same SHA, or oscillates with no code change.
5. Read each workflow file and check:
   - Trigger set (`on:`) is intentional.
   - `permissions:` block declared and minimal.
   - Third-party actions pinned by SHA or stable tag (no `@main`, `@master`, or floating major).
   - Secrets referenced by name, never logged.
   - Concurrency settings present where appropriate.
6. Cross-check **required status checks** in branch protection against the names of jobs actually defined in workflows. Drift is a red flag.
7. Look for self-hosted runners, deprecated actions, or actions from unverified publishers.
8. Score the Actions area (weight 15) per `scoring-model.md`.
9. Render a report focused on the **Actions** subsection, plus the standard top-level structure.

## Evidence to collect

- Workflow file paths.
- Trigger types (`push`, `pull_request`, `schedule`, `workflow_dispatch`, etc.).
- Failure rate per workflow / job over the last 30 days.
- Mean run duration trends if accessible.
- Required status checks configured on the default branch.
- Secrets referenced.
- Action versions in use (and whether pinned).

Read-only commands (see `collection-guide.md` for full set):

```
gh workflow list
gh run list --limit 50
gh api repos/<owner>/<repo>/branches/<default>/protection/required_status_checks
ls -la .github/workflows
```

## Red flags

- [BLOCKER] Default branch CI is currently red.
- [HIGH] Required status check name in branch protection does not match any workflow job (drift).
- [HIGH] Third-party action used at `@main` or `@master`.
- [HIGH] Workflow has no explicit `permissions:` block (defaults to broad).
- [HIGH] `GITHUB_TOKEN` granted `write` where `read` would suffice.
- [HIGH] Secrets are echoed (e.g., `echo "$SECRET"` in a step).
- [MEDIUM] Workflow uses deprecated action versions (e.g., `actions/checkout@v2`).
- [MEDIUM] Single job has > 20% failure rate without a triage record.
- [MEDIUM] Self-hosted runner without hardening notes.
- [LOW] Workflows lack a clear name or comment header.

## Output format

Use the standard contract from `output-contract.md`, with the **Detailed Findings → Actions** subsection populated in depth. Other subsections may be marked `Not inspected (actions-only mode)`.

## Safety rules

- Read-only. Never enable, disable, delete, or trigger a workflow.
- Never edit a workflow file. Recommendations to change workflows must appear under **Approval Required Before Destructive Actions** when they would change CI behavior.

## When to escalate

If you find that branch protection is missing or required checks are absent entirely, recommend running `/github-health full <repo>` to capture systemic issues across the repository.

## What not to do

- Do not recommend "auto-merge" of any kind, ever, in V1.
- Do not suggest disabling failing workflows to "make CI green".
- Do not paraphrase the value of any secret.
