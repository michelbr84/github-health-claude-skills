---
name: github-health-full
description: "Run an end-to-end health audit of a GitHub repository covering main branch, Actions, pull requests, branches, issues, security alerts, dependencies, documentation, releases, permissions, and Linear sync. Triggers on `/github-health full <repo>`, `/github-health standard <repo>`, `/github-health deep <repo>`, `/github-health quick <repo>` for a quick subset, and requests like \"audit the whole repo\" or \"give me a complete health check\". Read-only; destructive recommendations are approval-gated."
---

# github-health-full

Use this skill when the user wants a **complete** health audit. It is the default behavior when `/github-health <repo>` is invoked without a mode.

## When to trigger

- `/github-health <repo>`
- `/github-health full <repo>`
- `/github-health standard <repo>`
- `/github-health deep <repo>`
- `/github-health quick <repo>` — run the quick subset only.
- Natural-language requests for a comprehensive review.

## Required inputs

- GitHub repository URL.
- Optional mode (`full`, `standard`, `deep`, `quick`).

## Reference files (read these before producing a report)

- `github-health/references/github-health-checklist.md`
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. **Restate the scope.** Confirm the repository URL and mode. Tell the user which areas you will inspect and how long it may take.
2. **Collect evidence by area** using the read-only methods in `collection-guide.md`:
   - Main branch + branch protection
   - GitHub Actions
   - Pull requests
   - Branches
   - Issues
   - Security (umbrella)
   - CodeQL / code scanning
   - Dependabot — **always paginated** (`--paginate` with `per_page=100`); never report counts or severity tables from a non-paginated call. See `github-health-dependabot/SKILL.md` and `collection-guide.md`.
   - Secret scanning
   - Dependency graph
   - Permissions / collaborators / apps
   - Documentation
   - Releases / tags
   - Linear sync (if Linear is available)
3. **Apply severity** to every finding using `severity-model.md`.
4. **Apply scoring** using `scoring-model.md`. Compute area scores, sum, then apply override and floor rules.
5. **Render the report** following `output-contract.md` exactly.
6. **List recommended actions** split into `Do Now / Do This Week / Do Later`.
7. **List approval-gated destructive actions** under their own section.
8. **Stop.** Do not perform any state-changing action.

### Quick mode

When `quick` is specified, only collect:

- Default branch CI status.
- Branch protection presence/absence.
- Open security alerts (counts by type and severity). For Dependabot, the count must come from a paginated API call (`--paginate`, `per_page=100`); a single-page count is insufficient even in quick mode.
- Top-3 oldest open PRs.
- Top-3 stale branches.
- Documentation presence (README, SECURITY).

Render the same report structure but populate only the corresponding subsections. Mark omitted subsections as `Not inspected (quick mode)`.

### Deep mode

In addition to the standard audit, also collect:

- Workflow run history for the last 30 days to estimate flake rate per job.
- Branch divergence statistics (commits behind/ahead default).
- Issue and PR throughput trends (created vs closed) for the last 30 days.
- Recent force-push or history-rewrite indicators on protected branches.
- Linear cycle/project completion drift over the last 2 cycles (if Linear is available).

## Evidence to collect

See `github-health-checklist.md`. Every checklist item should resolve to one of: ✅ verified, ⚠️ likely, ❔ unverified.

## Red flags (force at least YELLOW; some force RED)

- Default branch CI red → RED.
- Open secret scanning alerts → RED.
- Open malware alerts → RED.
- Critical Dependabot alerts open → RED.
- Untriaged high-severity CodeQL alerts → at least YELLOW; RED if many.
- Branch protection missing on a serious project → at least YELLOW.
- PR mergeable but checks pending → blocks any merge recommendation.
- Linear "Done" without merged PR evidence → at least YELLOW.
- No `SECURITY.md` → at least YELLOW.

## Output format

Use the full structure from `output-contract.md`. All Detailed Findings subsections are required in `full`, `standard`, and `deep` modes. In `quick` mode, omitted subsections must be marked `Not inspected (quick mode)`.

## Safety rules

- Read-only. Never delete branches, merge PRs, dismiss alerts, change protection, modify Linear, rotate secrets, create releases, or rewrite history.
- Surface every potentially destructive recommendation under **Approval Required Before Destructive Actions** with rationale and rollback note.
- See `safety-rules.md`.

## When to escalate

If during a narrow follow-up audit a systemic issue is discovered (e.g., missing branch protection, missing SECURITY.md, missing CI), recommend running this skill in `full` mode. State the recommendation in the **Final Recommendation** section.

## What not to do

- Do not collapse findings — every area must have its own subsection or be explicitly marked `Not applicable` / `Not inspected`.
- Do not declare GREEN while any override rule applies.
- Do not invent severity. Unverified findings are INFO and labeled as such.
- Do not include secrets or tokens in any form. Refer by ID only.
