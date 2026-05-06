---
name: github-health-improve
description: Apply score-improving changes to a GitHub repository based on the latest GitHub Health Report. Triggers on /github-health-improve commands and on natural-language requests like "raise this repo's health score", "apply the next improvement", "ratchet up the score". Reads the most recent saved report, picks the next highest-leverage improvement, optionally applies it on a non-main branch, opens a PR, and (when explicitly enabled) merges and re-audits. Approval-gated by default. Hard-stops on any red Action, conflict, secret detection, or destructive-operation requirement.
---

# github-health-improve

You take an existing GitHub Health Report and apply the next score-improving change. You never modify `main` directly, never merge while checks are red or pending, never weaken security or branch protection, and never rewrite history.

This skill is the executor. The audit/report skill (`github-health`) remains the inspector. Use the audit's report as input; produce code changes, a PR, and a delta report as output.

## When to trigger

Trigger this skill when the user:

- Sends `/github-health-improve <repo-path-or-url> [flags]`.
- Asks to "apply the next improvement", "raise the score", "ratchet up the health", "fix the LICENSE / CODEOWNERS / SECURITY", "act on the audit report", or similar.
- Has a recent GitHub Health Report saved under `.github-health-reports/<owner>-<repo>/` and asks to act on it.

If no recent report is available, run a quick audit first (`/github-health quick <repo> --save`) and tell the user. Do not begin executing changes without a report to anchor against.

## Required inputs

- A repository, given as a local clone path **or** a GitHub URL. If the user gives a URL but you do not have a clone, ask once whether to clone into a working directory.
- An optional **risk level**: `low` (default), `medium`, `high`. Risk level is a ceiling — lower-risk changes are always allowed at higher levels.
- An optional flag set described in *Modes*. Save flags from the audit contract (`--save`, `--save-to <path>`) work here too and apply to the improvement-plan, execution-summary, and delta reports.
- For `--dangerously-skip-approvals` combined with `--auto-merge`: a `--max-iterations <N>` value (1–5) is mandatory.
- For `--from-reports <path>`: an explicit directory of prior reports if not the default `.github-health-reports/<owner>-<repo>/`.

If a critical input is missing or ambiguous, ask exactly one clarifying question. Never invent a target repository.

## Modes

The skill has four modes. The first is the default; the others stack flags onto the default.

### 1. Default — approval-gated

```
/github-health-improve <repo> [--from-reports <path>] [--risk-level low|medium|high]
```

- Read the most recent saved report from `.github-health-reports/<owner>-<repo>/` (or `--from-reports`).
- Pick one next-best improvement from *Recommended Actions → Do Now / Do This Week* that is in scope for the chosen risk level.
- Show the user the **improvement plan**: rationale, files to touch, expected score impact, risks, branch name, commit message preview, PR title preview.
- **Stop and ask for approval** before any edit, commit, push, PR, or merge.

### 2. `--auto` — apply one improvement, do not merge

```
/github-health-improve <repo> --auto [--risk-level low] [--max-iterations 1] [--save]
```

- Apply one improvement automatically, in scope for the chosen risk level.
- Create a `health/ratchet-<YYYYMMDD>-<short-topic>` branch from the current default branch.
- Edit files. Run any local checks the repo defines (lint, format, build, test) if they're already configured. Do not invent new pipelines.
- Commit with the *Commit message style* below.
- Push the branch to `origin`.
- Open a pull request if the user has `gh` permission to do so.
- Wait for GitHub Actions on the PR (poll the run status) up to a reasonable timeout.
- **Stop before merge** — do not merge, even if checks are green, unless `--auto-merge` is also present.

### 3. `--auto --auto-merge` — apply, push, merge if green

```
/github-health-improve <repo> --auto --auto-merge --risk-level low --max-iterations 1 --save
```

- Everything `--auto` does, plus:
- After the PR's required checks complete, **merge only if every required check is green and the PR is `MERGEABLE` / `CLEAN`**.
- Never merge while any required check is `pending`, `queued`, `in_progress`, `failure`, `cancelled`, `timed_out`, `action_required`, `stale`, or `skipped` *for a job that the branch protection requires*.
- Never merge with conflicts, draft state, or unresolved review-requested-changes.
- After merge, run a **quick** verification audit (`/github-health quick <repo> --save`).
- Generate a *Health Delta Report*.

### 4. `--dangerously-skip-approvals --auto-merge` — autonomous ratchet

```
/github-health-improve <repo> --dangerously-skip-approvals --auto --auto-merge \
  --risk-level low --max-iterations 3 --target-score 95 --save
```

- Loop modes 2 → 3 up to `--max-iterations` times (hard cap: 5) or until `--target-score` is reached.
- Per iteration: read latest report → plan → branch → edit → push → PR → wait for Actions → merge if green → re-audit (`quick`) → diff scores → repeat.
- **`--max-iterations <N>` is mandatory** when `--dangerously-skip-approvals` and `--auto-merge` are combined. The skill refuses to start otherwise.
- **The skill must hard-stop** the moment any of the *Stop conditions* below is met. It does not retry, does not coerce, does not "fix" the failing state on its own.
- Final iteration may escalate to a `full` verification audit if the user passed an explicit final-verification flag in the future, or asks for it inline; default is `quick` per iteration.

## Risk-level policy

Risk level is a **ceiling**. Lower-risk changes are always allowed; higher-risk changes require an equal-or-higher level.

### `low` (default)

Allowed:
- Add `LICENSE` (use SPDX-tagged content; ask once which license if unclear).
- Add or update `CONTRIBUTING.md`.
- Add or update `CHANGELOG.md` framing.
- Add `CODEOWNERS` populated from existing top contributors and obvious path ownership; never invent owners.
- README fixes (broken links, factual corrections, grammar, missing badges that already render).
- `SECURITY.md` improvements (clarify reporting channel, add disclosure timeline) — never weaken policy.
- Documentation reorganization, including moving prior reports under `.github-health-reports/`.
- GitHub Actions edits limited to comments, naming (`name:`), and non-behavioral docs (no permission changes, no step rewrites, no trigger changes).
- Adding a CodeQL **default** workflow only when (a) the repository has a CodeQL-supported dominant language detected via `gh api repos/.../languages`, (b) no existing CodeQL workflow is present, and (c) no secrets are introduced.
- Dependency bumps **only** when an open Dependabot PR already proposes the bump and its CI is green — in which case the action is to approve/merge that PR (still subject to `--auto-merge`), not to author a parallel bump.

### `medium`

All `low` changes plus:
- Test-only changes (adding tests, fixing flaky tests).
- Lint and format fixes via existing repo tooling (no new tools added without explicit approval).
- CI workflow improvements (least-privilege `permissions:` blocks, action-version pinning to a SHA).
- Dependency bumps with lockfile updates when no Dependabot PR exists, limited to non-major versions.
- CodeQL workflow tuning (paths, languages, schedule).
- Small config changes paired with documentation.

### `high`

All `low` and `medium` changes plus:
- Source code changes.
- Package upgrades (including major versions) not already proposed by Dependabot.
- Build system changes.
- Security remediation code changes (e.g., a sanitizer fix for an open Dependabot/CodeQL alert).

### Forbidden at every level

These are listed again in *Hard safety rules* — repeated here for the risk table to be self-contained.

- Force push.
- History rewrite (`rebase -i`, `commit --amend` of pushed commits, `filter-repo`, etc.).
- Branch deletion (local or remote).
- Secret rotation, deletion, or addition to repo settings.
- Weakening of branch protection, required checks, or any security setting.
- Disabling CI, tests, CodeQL, Dependabot, or secret scanning.
- Dismissing any Dependabot, CodeQL, secret scanning, or malware alert.
- Bypassing failed or pending checks to merge.
- Direct merge to `main` without a PR.

## Branch and commit conventions

**Branch name:**

```
health/ratchet-<YYYYMMDD>-<short-topic>
```

`<short-topic>` is a kebab-case noun (`codeowners`, `license`, `codeql`, `readme-links`, `security-md-disclosure`). Examples:

- `health/ratchet-20260505-codeowners`
- `health/ratchet-20260505-license`
- `health/ratchet-20260505-codeql`

**Commit message style** (Conventional Commits):

- `chore(health): <short improvement>` — hygiene/scaffolding.
- `docs(health): <short improvement>` — documentation only.
- `ci(security): <short improvement>` — workflow or security configuration changes.

Always include a one-paragraph body explaining *why this raises the score* and which audit finding it addresses, and footer the commit with `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`. Never bypass hooks (`--no-verify`) or signing.

## Procedure (one iteration)

Even when fully autonomous, every iteration follows the same numbered procedure. Logging each step in the *Execution Summary* report is mandatory.

1. **Locate the latest report.** Use `--from-reports <path>` if given; otherwise scan `.github-health-reports/<owner>-<repo>/` for the most recent `*-health-report.md` and parse its header (Mode, Date, Overall Status, Health Score, Saved to). If none exists, stop and tell the user to run `/github-health quick <repo> --save` first.
2. **Confirm clean working tree.** `git status --short` must be empty. If not, abort with a clear message; never auto-stash, never auto-commit.
3. **Confirm default branch and remote.** `git rev-parse --abbrev-ref HEAD` must be the default branch (or the user's intended base); `git fetch origin` must succeed; the local default must be in sync with `origin/<default>`.
4. **Pick the next improvement.** Read *Blockers* → *Attention Needed* → *Do Now* → *Do This Week* in that order. Drop any item that is out of scope for the risk level. Drop any item that requires destructive action. Drop any item already attempted in a previous iteration in the same run. Choose the highest-leverage remaining item. Write the **Improvement Plan** report.
5. **Approval gate.** In default mode, stop here and ask the user to approve. In `--auto`-or-higher modes, the user has already approved at the command level — proceed without an additional gate. (`--dangerously-skip-approvals` removes nothing here that wasn't already removed by `--auto`; see *What `--dangerously-skip-approvals` actually does*.)
6. **Branch.** `git switch -c health/ratchet-<YYYYMMDD>-<short-topic>` from the current default.
7. **Edit.** Apply the change. Make it minimal — one improvement per branch. Re-read the file you just wrote to verify it parses (Markdown link check, YAML lint for workflows, JSON validation for config).
8. **Local checks.** Run any pre-existing repo checks the change touches: `npm run lint`, `pytest`, `cargo check`, etc. Run only what already exists; do not invent pipelines. If a check fails, stop and report.
9. **Commit.** Stage *only* the files you intended to change (no `git add -A`). Commit with the message style above. Do not skip hooks. If a hook fails, fix the underlying issue and create a *new* commit; never amend a pushed commit.
10. **Push.** `git push -u origin health/ratchet-<YYYYMMDD>-<short-topic>`. Plain push only — never `--force`, `--force-with-lease`, or `+refspec`.
11. **Open PR.** Use `gh pr create --base <default> --head <branch> --title <conventional title> --body <body from template>`. Body links to the audit finding the change addresses, the previous report, and the planned delta report path.
12. **Wait for Actions.** Poll `gh run list --branch <branch>` and `gh pr checks <number>` until either every required check is conclusive or the timeout is hit. Surface the run URLs in the execution summary. If a required check fails, stop the iteration and do not merge.
13. **Merge?** Only if `--auto-merge` is present, the PR is `MERGEABLE` / `CLEAN`, every required check is `success`, and no review has requested changes. Merge using `gh pr merge --squash --delete-branch=false` (do not delete the remote branch automatically — see safety rules).
14. **Verification audit.** After merge: `/github-health quick <repo> --save`. The skill must wait for the new report file to be written before reading it.
15. **Compute the delta.** Parse the new report's score and findings; compare to the previous report. Write the **Health Delta Report**. When the previous and new reports include Dependabot alert counts, verify both were obtained from paginated calls (`--paginate`, `per_page=100`); if either is unconfirmed, label the Dependabot delta `Unverified — pagination not confirmed` and do not credit the score change to a Dependabot drop.
16. **Loop or stop.** If iterations remain *and* the target score is not yet reached *and* no stop condition has been met, return to step 1 with the new report as input.

## Stop conditions (any one halts the loop immediately)

The autonomous loop stops on the first occurrence of any of these:

- Required GitHub Actions check is `failure`, `cancelled`, `timed_out`, `action_required`, or returns `skipped` for a required job.
- Required check is still `pending`/`queued`/`in_progress` after the configured timeout.
- PR is not `MERGEABLE` or has merge conflicts (`mergeStateStatus` not `CLEAN`).
- Any reviewer has requested changes that are not yet resolved.
- Secret scanning push protection blocks the push, or any local check detects an apparent secret in the diff (entropy heuristic, or any of: PEM block, AWS-key-shaped string, GitHub PAT, JWT, Slack token, OpenAI key prefix, Stripe key prefix). Stop and warn — never bypass push protection.
- Working tree is unexpectedly dirty between steps, or untracked files appear that the skill did not create.
- A planned change would touch a forbidden surface (branch protection, security settings, secrets, workflows beyond the risk-level allowlist).
- The chosen improvement has been attempted earlier in the same run and failed (no retry loop).
- Any user-visible warning indicates ambiguity (e.g., merge would close an unrelated PR, branch name collision, default branch changed mid-run).
- `--max-iterations` reached or `--target-score` met.

When a stop condition fires, the skill writes whatever it has into the *Execution Summary* and stops. It does not continue with the next iteration "around" the failure.

## Hard safety rules (apply in every mode, including dangerous)

The skill **never**:

- Force pushes.
- Rewrites history (`rebase -i`, amend of pushed commits, `filter-repo`, `reset --hard` past pushed commits).
- Deletes local or remote branches.
- Deletes issues or closes PRs.
- Dismisses Dependabot, CodeQL, secret scanning, or malware alerts.
- Rotates, deletes, or adds secrets.
- Weakens branch protection, repository security settings, or required-status-check rules.
- Disables CI, tests, CodeQL, Dependabot, or secret scanning.
- Commits `.env`, private keys, tokens, credentials, or generated health reports — unless the user explicitly configures saving and a path that the user has confirmed.
- Merges while any required check is red, pending, missing, skipped (in a required job), or inconclusive.
- Merges directly to the default branch without a PR.
- Modifies production deployment secrets, environment protections, or deploy keys.
- Claims a score improved without a fresh report verifying it. If no fresh report is available (e.g., audit is still running), report the change as **estimated** and label it as such in the delta.
- Claims that Dependabot alerts dropped (or that any "exogenous alert drop" raised the score) unless the new count was obtained from a **paginated** API call (`--paginate` with `per_page=100`) on both the previous and the new report. A drop computed against a single-page (≤30) baseline or measurement is not a verified drop and must be labeled `Unverified — pagination not confirmed` in the delta. See `github-health-dependabot/SKILL.md` for the exact commands.

These rules are not relaxed by any flag, including `--dangerously-skip-approvals`.

## What `--dangerously-skip-approvals` actually does (and does not)

`--dangerously-skip-approvals` skips **only the skill's own conversational approval gates**. It removes the "should I commit this?", "should I push?", "should I merge?" prompts the skill would otherwise ask between steps in approval-gated mode.

It **does not** bypass:

- **Claude Code permissions.** If a tool call requires user permission in the current Claude Code session, that prompt is enforced by the harness, not the skill.
- **Operating-system permissions.** File-system, network, or process permissions are unchanged.
- **GitHub permissions.** The token's scopes still apply; the skill cannot do anything `gh auth status` says it can't.
- **Branch protection or required checks.** GitHub still enforces these. If protection requires a review, the skill cannot merge without one.
- **Secret scanning push protection.** GitHub still blocks pushes that contain secrets; the skill must respect the block.
- **Linear permissions or any other connector.** Out of scope for this skill in V1; do not write to Linear regardless of mode.
- **Repository-level rulesets.** Same as branch protection — enforced upstream.
- **Pre-commit / pre-push hooks** the user has configured. The skill never uses `--no-verify`.

In other words, `--dangerously-skip-approvals` is a *user-side* concession that the user trusts the skill not to ask between steps. It is not a privilege escalation against any external system.

## Output / reports

When `--save` (or `--save-to <path>`) is present, the skill writes three Markdown files per iteration:

1. **Improvement plan** — what we'll change, why it raises the score, the predicted score impact, the branch name, the commit/PR titles. Template: `templates/improvement-plan.md`.
2. **Execution summary** — a step-by-step log of what the skill actually did (branch, commits, push, PR URL, Actions runs and conclusions, merge result, verification audit path). Template: `templates/execution-summary.md`.
3. **Health delta report** — score before / after, findings resolved / unchanged / newly discovered, branch, commits, PR, Actions, merge, next recommended improvement. Template: `templates/health-delta-report.md`.

**Default save path** for each:

```
.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-improvement-<short-topic>.md
.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-execution-<short-topic>.md
.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-delta-<short-topic>.md
```

Persistence rules from `github-health/references/output-contract.md` apply unchanged: non-overwriting, `Saved to:` metadata line, security warning when the path is in a tracked directory, never auto-committed.

If the user passed `--save-to <path>`, treat `<path>` as the **directory prefix** for these three files (the skill picks the filenames). If the path looks like a single `.md` filename, save the *delta* report there and skip the other two unless the user explicitly asks for all three.

## Health Delta Report — required content

The delta report (template: `templates/health-delta-report.md`) must contain at least:

- Previous report path.
- New report path.
- Previous score.
- New verified score (or **estimated** score, clearly labeled, when no fresh report is available).
- Score delta.
- Findings resolved (severity + title).
- Findings unchanged.
- Findings newly discovered.
- Branch name.
- Commits (SHA + subject) created on that branch.
- PR number and URL.
- GitHub Actions result (per required check).
- Merge result (`merged` / `not merged: <reason>`).
- Next recommended improvement (one suggestion for the next iteration or run).

If any item is unverified, label it `Unverified — <why>`. Never invent a verified score.

## When to escalate to a human

Stop the loop and ask the user when:

- The chosen improvement requires risk level higher than what was passed.
- A required check needs reviewer interaction (request-changes, approve-required).
- A change would touch any forbidden surface listed in *Hard safety rules*.
- Two consecutive iterations produced no score change.
- The repository's default branch changed during the run.
- A new BLOCKER appears in the verification report that did not exist before — investigate before continuing.

## What not to do

- Do not chain multiple improvements onto a single branch. One improvement per branch keeps blame and rollback simple.
- Do not invent owners for `CODEOWNERS`. Use only logins that have actually committed to the relevant paths.
- Do not "fix" failing CI by silencing it. Stop and report.
- Do not stash, force-add, or auto-format files outside the change's intended scope.
- Do not run any external network call beyond `git`, `gh`, and the repo's own tooling.
- Do not delete the source branch after merge. Cleanup is a separate, approval-gated activity (`/github-health cleanup-plan`).
- Do not claim the score went up without a fresh report. Use the *estimated* label whenever the verification audit hasn't completed.
- Do not echo any secret, partial secret, or disambiguating substring into any report or commit message.
