---
name: github-health-secret-scanning
description: "Audit secret scanning alerts, bypasses, leaked credentials, .env hygiene, and workflow secret exposure in a GitHub repository. Triggers on `/github-health secret-scanning <repo>` and requests like \"any leaked secrets\", \"review exposed tokens\", or \"audit secret hygiene\". Read-only; never dismisses alerts or rotates secrets."
---

# github-health-secret-scanning

## When to trigger

- `/github-health secret-scanning <repo>`
- Questions about leaked secrets, exposed tokens, push protection, or `.env` hygiene.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 9.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Confirm secret scanning and push protection are enabled.
2. List open secret scanning alerts. Refer to each by ID only — never echo the secret value.
3. List bypass requests and their state.
4. Inspect `.gitignore` for coverage of `.env`, `.env.*`, `*.pem`, `*.key`, `*.crt`, `*.p12`, credentials directories, and IDE configs that may contain tokens.
5. Heuristically inspect recent commits for accidental commits of secret-like content (without echoing values).
6. Cross-check workflows for steps that might log secrets (e.g., `set -x`, `echo "$TOKEN"`, `printenv`).
7. Score the Security area accordingly.
8. Render a report focused on **Secret Scanning** within Security.

## Evidence to collect

```
gh api repos/<owner>/<repo>/secret-scanning/alerts?state=open
cat .gitignore | head -100
ls -la .env .env.* 2>/dev/null
grep -nE "echo[[:space:]]+\".*\$\{?[A-Z_]+\}?\"" .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null
```

Use the alert resource type (e.g., `aws_access_key_id`, `github_personal_access_token`) — never the secret value.

## Red flags

- [BLOCKER] Any open secret scanning alert.
- [BLOCKER] `.env` or other secret-bearing file currently tracked in the repository.
- [HIGH] Push protection disabled.
- [HIGH] Secret scanning disabled.
- [HIGH] Workflow step that echoes a secret variable.
- [MEDIUM] `.gitignore` missing common secret patterns.
- [MEDIUM] Many bypass requests pending review.
- [LOW] Secret-like content in commit messages.

## Output format

Use the standard contract. Populate **Detailed Findings → Security → Secret Scanning** in depth. Include a per-alert table with: alert ID, resource type, location reference, state, recommended action.

## Safety rules

- **Never echo secret values.** Use alert ID and resource type only.
- Never dismiss alerts or approve bypasses.
- Recommendations to rotate or revoke secrets go under **Approval Required Before Destructive Actions**, with steps the user should take manually (provider console, CI secret store, deployment platform).
- Recommendations to remove secrets from history (e.g., `git filter-repo`) are listed as manual actions only, never automated.

## When to escalate

- If alerts indicate exposure across many repos, recommend an organization-level audit beyond this repo's scope.
- If a leaked secret is tied to production infrastructure, treat it as a BLOCKER and recommend immediate rotation as the highest-priority Do Now item (still the user's manual action).

## What not to do

- Do not include the secret value, partial value, or any disambiguating substring in the report.
- Do not propose adding a secret to a `.env.example` to "document the leak" — that perpetuates the leak.
- Do not assume an alert is a false positive without explicit user confirmation backed by evidence.
