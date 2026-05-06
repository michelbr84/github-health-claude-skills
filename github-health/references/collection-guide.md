# Evidence Collection Guide

This guide describes **read-only** ways to collect the evidence each skill needs. Use whichever tool is available in the current environment. If none can answer a question, mark the relevant finding as **Unverified** rather than guessing.

> All commands here are read-only. None of them mutate repository, GitHub, or Linear state.

## Tool preference order

When more than one tool is available, prefer them in this order:

1. **Local Git working copy** (when the user has cloned the repo and granted access). Fast and offline-friendly.
2. **GitHub CLI (`gh`)** in read-only commands. Authenticated by the user.
3. **GitHub MCP / connector** when present. Programmatic, structured.
4. **GitHub UI** evidence the user pastes back. Use as last resort for any single fact.

If multiple tools agree, cite the most authoritative (typically GitHub API/CLI). If they disagree, surface the disagreement in the finding.

## What to collect, by area

### Main branch

- Default branch name.
- Latest commit SHA on default branch.
- Latest CI run status on default branch.
- Branch protection / ruleset summary for the default branch.

Read-only commands:

```
git rev-parse --abbrev-ref origin/HEAD
git log -1 --pretty=format:"%H %s" origin/HEAD
gh api repos/<owner>/<repo> --jq '.default_branch'
gh api repos/<owner>/<repo>/branches/<default> --jq '.protected, .protection'
gh run list --branch <default> --limit 5
```

### GitHub Actions

- Workflow files under `.github/workflows/`.
- Recent run history per workflow.
- Required status checks configured on protected branches.
- `permissions:` blocks in each workflow.

```
ls -la .github/workflows
gh workflow list
gh run list --limit 30
gh api repos/<owner>/<repo>/branches/<default>/protection/required_status_checks
```

### Pull requests

- Open PRs (count, ages, mergeability, review state, checks).
- Stale PRs (no activity > N days).
- Draft PRs.

```
gh pr list --state open --limit 200 --json number,title,author,createdAt,updatedAt,isDraft,mergeable,reviewDecision,statusCheckRollup,headRefName
```

### Branches

- All branches, sorted by last commit.
- Merged branches not yet deleted.

```
git fetch --all --prune
git for-each-ref --sort=-committerdate refs/remotes/origin --format="%(committerdate:iso8601) %(refname:short) %(authorname)"
git branch -r --merged origin/<default>
```

### Issues

- Open issues, labels, milestones, assignees.

```
gh issue list --state open --limit 500 --json number,title,labels,milestone,assignees,createdAt,updatedAt
gh label list
gh api repos/<owner>/<repo>/milestones --jq '.[] | {title,state,due_on}'
```

### Security — overview

```
gh api repos/<owner>/<repo> --jq '.security_and_analysis'
```

### Code scanning (CodeQL and others)

```
gh api repos/<owner>/<repo>/code-scanning/alerts?state=open
```

### Dependabot

The `repos/<owner>/<repo>/dependabot/alerts` endpoint silently truncates to a single page (default 30 items, max 100 per page). **Any count, severity breakdown, or manifest breakdown derived from a non-paginated call is wrong and must not be reported as the total.** Always combine `--paginate` with `per_page=100`. A bare `gh api repos/<owner>/<repo>/dependabot/alerts` (no `--paginate`, no `per_page`) is **insufficient** for repositories with many alerts — for example, a repo with 71 open alerts will report 30 unless paginated.

If the GitHub UI count and the API count disagree, treat the mismatch as a verification issue: re-run paginated and reconcile. Do not extrapolate the alert count from a single page.

PowerShell — open alert count, severity, manifest:

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].number' | Measure-Object -Line
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].security_vulnerability.severity' | Sort-Object | Group-Object
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].dependency.manifest_path' | Sort-Object | Group-Object
```

POSIX shell — open alert count, severity, manifest:

```
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].number' | wc -l
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].security_vulnerability.severity' | sort | uniq -c
gh api --paginate "repos/<owner>/<repo>/dependabot/alerts?state=open&per_page=100" --jq '.[].dependency.manifest_path' | sort | uniq -c
```

Dependabot PRs and config:

```
gh pr list --search "is:open author:app/dependabot"
ls -la .github/dependabot.yml
```

### Secret scanning

```
gh api repos/<owner>/<repo>/secret-scanning/alerts?state=open
```

(Read-only. Bypass requests should be reviewed manually in the GitHub UI.)

### Dependency graph and supply chain

- Manifest files (e.g., `package.json`, `Cargo.toml`, `requirements.txt`, `go.mod`, `pyproject.toml`).
- Lockfiles (e.g., `package-lock.json`, `Cargo.lock`, `poetry.lock`, `go.sum`).
- `.github/dependabot.yml`.
- `.github/workflows/*` for `dependency-review-action`.

### Permissions

- Collaborators, teams, apps, webhooks, environments.

```
gh api repos/<owner>/<repo>/collaborators
gh api repos/<owner>/<repo>/teams
gh api repos/<owner>/<repo>/installations
gh api repos/<owner>/<repo>/hooks
gh api repos/<owner>/<repo>/environments
```

### Documentation

- Presence and freshness of `README.md`, `SECURITY.md`, `ROADMAP.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CODEOWNERS`, `.github/ISSUE_TEMPLATE/`, `.github/PULL_REQUEST_TEMPLATE.md`.

```
ls -la README.md SECURITY.md ROADMAP.md CONTRIBUTING.md CHANGELOG.md CODEOWNERS .github/ISSUE_TEMPLATE .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null
```

### Releases

```
gh release list --limit 30
gh api repos/<owner>/<repo>/tags --jq '.[].name' | head -50
```

### Linear sync (when Linear is available)

- Read Linear issues, statuses, cycles, projects, milestones.
- Cross-reference Linear issue IDs with PR titles, branch names, and commit messages.
- Read-only access only. Do not modify any Linear record.

### Repository hygiene

- Recent commits to default branch.
- `.gitignore` coverage for secrets and lockfiles.
- License file presence.

```
git log --oneline -50 origin/<default>
cat .gitignore | head -100
ls LICENSE LICENSE.md COPYING 2>/dev/null
```

## Data quality rules

- Always fetch before reading remote refs (`git fetch --all --prune`).
- Treat any data older than 60 minutes (in a long session) as potentially stale.
- If counts disagree between two sources (e.g., `gh pr list` vs UI), state both and flag the inconsistency. For Dependabot specifically, a UI/API mismatch most often means the API call was not paginated — re-run with `--paginate` and `per_page=100` before reporting either number.
- If access is denied (private repo, missing scope), record `Unverified — access denied` and continue.

## Privacy rules

- Do not include personal email addresses, phone numbers, or home addresses found in commits or files.
- Do not echo secrets or tokens.
- Use redacted IDs when referencing secret scanning alerts.
- Do not include the contents of `.env` files in the report, even if they are tracked.
