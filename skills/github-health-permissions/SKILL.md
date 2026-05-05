---
name: github-health-permissions
description: Audit collaborators, teams, GitHub Apps, webhooks, environment protections, token permissions, and least privilege. Triggers on /github-health permissions <repo> and on requests like "audit access", "who has push", "are tokens least privilege". Read-only; never modifies access or settings.
---

# github-health-permissions

## When to trigger

- `/github-health permissions <repo>`
- Questions about access, collaborators, teams, apps, webhooks, environment protections, or token scopes.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 11.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. List collaborators and their permission levels.
2. List teams with access and their permission levels.
3. List installed GitHub Apps with the scopes granted to each.
4. List webhooks and their target URLs (mask sensitive components if any).
5. List environments and their protection rules (required reviewers, wait timers, branch policy).
6. Inspect default `GITHUB_TOKEN` permissions for the repository.
7. Inspect each workflow's `permissions:` block for least privilege.
8. Identify outside collaborators.
9. Score the Security area (in part) per `scoring-model.md`.
10. Render a report focused on **Permissions** (within Security or as a standalone subsection).

## Evidence to collect

```
gh api repos/<owner>/<repo>/collaborators --jq '.[] | {login, permissions}'
gh api repos/<owner>/<repo>/teams --jq '.[] | {name, permission}'
gh api repos/<owner>/<repo>/installations
gh api repos/<owner>/<repo>/hooks
gh api repos/<owner>/<repo>/environments
gh api repos/<owner>/<repo>/actions/permissions/workflow
```

## Red flags

- [HIGH] Many collaborators with `admin` access.
- [HIGH] Outside collaborators with `write` or `admin` without justification.
- [HIGH] GitHub App granted broad scopes (e.g., `admin:repo_hook`, `repo`).
- [HIGH] Webhook targeting a personal endpoint or short-lived URL.
- [HIGH] Workflow `permissions:` is unset (defaults to broad), or grants `write` on `contents` unnecessarily.
- [MEDIUM] Production environment has no required reviewers.
- [MEDIUM] No environment protections at all on a project that deploys.
- [LOW] Inactive collaborators (no activity in > 6 months) still hold elevated access.

## Output format

Use the standard contract. Populate **Detailed Findings → Security** with a Permissions sub-table: actor, type (user / team / app / webhook / environment), permission/scope, judgment, recommendation.

## Safety rules

- Never change access, scopes, or webhooks.
- Recommendations to revoke or downgrade access go under **Approval Required Before Destructive Actions**, with rationale and rollback note.
- For webhooks pointing to suspicious or unknown endpoints, recommend manual verification before any change.
- Never include webhook secrets, app credentials, or tokens.

## When to escalate

- For broader security posture, escalate to `github-health-security`.
- For workflow permissions specifically, also use `github-health-actions`.

## What not to do

- Do not include personal information about collaborators beyond their GitHub handle.
- Do not assume "needs admin" — least privilege is the default; the user must justify exceptions.
- Do not propose mass revocations. Each revocation needs its own justification.
