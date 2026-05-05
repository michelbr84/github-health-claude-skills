# Safety Rules

These rules apply to every skill in this repository. They are non-negotiable in V1.

## Core principle

The skills are **read-only by default**. State-changing actions on GitHub, Git, Linear, or any external system require **explicit user approval captured in the conversation**. Approval must be specific to the action; "go ahead" without context does not authorize destructive automation.

## Never do these without explicit approval

The following list is exhaustive for V1. Each item is forbidden without an explicit approval message that names the specific action and the specific target.

- Delete a branch (local or remote).
- Merge a pull request.
- Close a pull request.
- Re-open a closed pull request to act on it.
- Close an issue.
- Re-open a closed issue to act on it.
- Dismiss a CodeQL or other code scanning alert.
- Dismiss a Dependabot alert.
- Dismiss a secret scanning alert.
- Approve a secret scanning bypass request.
- Change repository settings (visibility, default branch, features).
- Change branch protection rules.
- Change repository or organization rulesets.
- Create, edit, or delete a Linear issue, project, cycle, or comment.
- Move a Linear issue between statuses.
- Rotate, regenerate, or delete a secret in any system.
- Create a release or tag.
- Push commits to any branch.
- Force-push.
- Rewrite history (rebase, amend, filter-branch, reset --hard, etc.).
- Run a workflow manually (`workflow_dispatch`).
- Edit `.github/` configuration files.
- Edit `dependabot.yml`, `CODEOWNERS`, branch protection JSON, or rulesets JSON.

## Always do these

- Separate **verified facts**, **likely conclusions**, **risks**, **recommended actions**, **destructive actions requiring approval**, and **manual verification commands** in the report.
- Mark unverified findings explicitly. Never invent evidence.
- Refer to secrets, tokens, and credentials by ID or label only. Never echo their values.
- Surface every potentially destructive recommendation under **Approval Required Before Destructive Actions**.
- For each destructive recommendation, include: the exact action, why it is necessary, and a one-line rollback note.
- For each manual verification command suggested to the user, include a one-line description of what it does and what it does **not** do.

## Approval format

Treat as approval only a message from the user that:

1. Identifies the action ("delete the branch", "merge the PR", "dismiss the alert").
2. Identifies the target ("`feature/old-x`", "PR #123", "alert ID 4567").
3. Confirms intent ("yes, please", "go ahead", "do it now").

A bare "yes" without context is **not** sufficient. Ask the user to restate the action and target.

## Linear-specific safety

- Linear is treated as the operational source of truth. Reading is allowed. Writing is approval-gated like any other destructive operation.
- Do not transition a Linear issue to "Done" because GitHub shows a merged PR, unless the user explicitly approves the state change for that specific issue.
- Do not modify Linear issue titles or descriptions on the assumption that the GitHub PR title is more correct.
- Auto-close risks (e.g., a PR title containing `Closes PROJ-123`) must be flagged but not pre-emptively edited.

## Secrets and credentials

- Never include the value of a secret in the report.
- If a secret may have been exposed, recommend rotation but do not perform it.
- If `.env`, `.pem`, or `.key` files appear in tracked history, recommend removal-from-history workflows but do not run them.
- If a secret scanning alert names a token, the report should refer to it by alert ID only.

## Manual verification commands

Skills may suggest read-only commands to the user. When suggesting a command, the skill must:

1. State explicitly that it is **read-only**.
2. Show the exact command.
3. Describe expected output shape.
4. State what the command does **not** do.

Example:

```
This command lists open Dependabot alerts and is read-only. It does not dismiss,
acknowledge, or modify any alert.

  gh api -H "Accept: application/vnd.github+json" \
    "/repos/<owner>/<repo>/dependabot/alerts?state=open"
```

## When in doubt

If a recommendation could change state and the safety classification is unclear, treat it as destructive. Surface it under **Approval Required Before Destructive Actions**.
