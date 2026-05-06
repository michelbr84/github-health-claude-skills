# Changelog

All notable changes to this project are documented in this file. The format is loosely based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to semantic versioning.

## [0.2.1] — 2026-05-06

### Fixed

- **Dependabot alert pagination correctness.** Fixed a counting bug where Dependabot alert totals, severity breakdowns, and manifest breakdowns could be silently truncated to a single API page (default 30 items) for repositories with many open alerts. Observed in FluxSwap, where the GitHub UI showed 71 open alerts but a non-paginated `gh api repos/<owner>/<repo>/dependabot/alerts` returned only 30. All Dependabot alert collection now requires `--paginate` with `per_page=100`.

### Changed

- `skills/github-health-dependabot/SKILL.md`: added a *Pagination is mandatory* section, replaced the non-paginated example with paginated PowerShell and POSIX commands for count, severity, and manifest breakdown, and added explicit *What not to do* rules against single-page totals and silent UI/API mismatches. Score must not be recalculated from a partial page.
- `skills/github-health-security/SKILL.md`: Dependabot evidence now uses paginated calls; the umbrella security audit must not derive Dependabot counts from a single page. Code scanning and secret scanning calls were also updated to `--paginate`/`per_page=100` for consistency.
- `skills/github-health-full/SKILL.md`: Dependabot collection note added in the procedure and quick-mode subsection so the full and quick audits both require paginated counts.
- `skills/github-health-improve/SKILL.md`: hard safety rule added — the skill must not claim that Dependabot alert drops (or any "exogenous alert drop") raised the score unless both the previous and the new counts came from paginated API calls. The delta-computation step labels Dependabot deltas `Unverified — pagination not confirmed` when pagination is uncertain.
- `github-health/references/collection-guide.md`: rewrote the *Dependabot* subsection to document the truncation behavior, list paginated PowerShell and POSIX commands, and warn that a UI/API count mismatch most often signals a non-paginated call. Data quality rules updated accordingly.
- `agents/security-auditor.md` and `agents/dependency-auditor.md`: replaced the bare `gh api repos/.../dependabot/alerts?state=open` example with the paginated form, with a note pointing to the canonical collection guide.
- `evals/evals.json`: added `dependabot-pagination-truncation` scenario with a 71-vs-30 mismatch.
- `evals/expected-behavior.md`: added the matching expected-behavior entry.

### Notes

- Markdown-only patch. No executable scripts added. `install.sh` unchanged.
- Templates were not modified — none of them embed the non-paginated command. The paginated commands live in skills and references where the audit procedures are described.
- All `SKILL.md` files retain their existing YAML frontmatter (`name` / `description` only).

## [0.2.0] — 2026-05-05

### Added

- New skill: `skills/github-health-improve/SKILL.md`. Reads the most recent saved GitHub Health Report and applies the next score-improving change. The skill is approval-gated by default and supports an autonomous ratchet loop under explicit flags. It is the *executor* counterpart to the existing audit/report skill, which remains read-only.
- New flags on `/github-health-improve`:
  - `--auto` — apply one in-scope improvement automatically (branch, commit, push, open PR, wait for Actions). Does **not** merge.
  - `--auto-merge` — when combined with `--auto`, merge the PR only when every required check is green and the branch is mergeable. Never merge red, pending, missing, skipped-in-required, or inconclusive.
  - `--dangerously-skip-approvals` — skip the skill's own conversational approval gates between steps. Mandatory `--max-iterations` when combined with `--auto-merge`.
  - `--max-iterations <N>` — maximum improvement cycles (default 1, hard maximum 5).
  - `--target-score <N>` — stop once the verified score is ≥ N (default 100).
  - `--risk-level low|medium|high` — controls which classes of improvement are allowed (default `low`).
  - `--dry-run` — simulate without modifying files.
  - `--from-reports <path>` — explicit prior-report directory.
  - `--save` / `--save-to <path>` — persist the improvement plan, execution summary, and delta report (uses the same persistence contract as audits).
- Risk-level policy: `low` covers documentation/governance and the default CodeQL workflow; `medium` adds tests, lint/format, CI improvements, and non-major dependency bumps; `high` adds source-code, build, and security-remediation changes.
- Branch convention `health/ratchet-<YYYYMMDD>-<short-topic>` and Conventional Commits messages (`chore(health): …`, `docs(health): …`, `ci(security): …`).
- Three new templates supporting repeatable improvement runs:
  - `templates/improvement-plan.md`
  - `templates/execution-summary.md`
  - `templates/health-delta-report.md`
- README section documenting the new skill, modes, flags, risk levels, hard safety rules, the precise scope of `--dangerously-skip-approvals`, and FluxSwap usage examples.
- Brief cross-link in `github-health/SKILL.md` so the audit orchestrator can route users to `/github-health-improve` when they want to act on a report. The orchestrator itself remains audit/report-only.
- Ten new evaluation entries covering: default-mode approval, `--auto` non-merge behavior, `--auto-merge` merge gating, the mandatory `--max-iterations` for dangerous mode, hard-stop on red Actions, refusal of force push, refusal to weaken branch protection, delta-report generation, and the `estimated` score label when no fresh report is available.

### Hard safety rules (unchanged by any flag)

- No force push, no history rewrite, no branch deletion.
- No issue or PR closure.
- No dismissal of Dependabot, CodeQL, secret scanning, or malware alerts.
- No secret rotation, deletion, or addition.
- No weakening of branch protection or required checks.
- No disabling of CI, tests, CodeQL, Dependabot, or secret scanning.
- No merge with red, pending, missing, skipped-in-required, or inconclusive checks.
- No direct merge to the default branch without a PR.
- No modification of production deployment secrets or environment protections.
- No commit of `.env`, private keys, tokens, or generated health reports unless explicitly configured.
- No claim of a score improvement without a fresh report; otherwise the change is labeled **estimated**.

### Notes

- `--dangerously-skip-approvals` skips **only** the skill's own conversational approval gates. It does not bypass Claude Code permission prompts, the operating system, GitHub permissions, branch protection, required checks, secret scanning push protection, Linear, repository rulesets, or pre-commit/pre-push hooks. The skill never uses `--no-verify`.
- This release is a feature addition (autonomous executor mode), hence the `0.2.0` minor bump rather than a `0.1.x` patch.
- No install-script changes, no new package-manager files, no executable code added beyond the existing `install.sh`.

## [0.1.2] — 2026-05-05

### Added

- Optional Markdown report saving instructions for the `/github-health` orchestrator. By default, audit reports are still shown in chat only and **no file is written**. Three new flags control persistence:
  - `--save` — print the report in chat and save a Markdown copy.
  - `--save-only` — save the Markdown report and print only a short summary plus the saved path.
  - `--save-to <path>` — save the Markdown report to the user-supplied path; parent directories are created as needed.
- Default save path convention: `.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-<mode>-health-report.md`.
- Optional `Saved to: <path>` metadata line in the report header, populated only when persistence is used.
- Non-overwriting save policy: if the target file already exists, the skill stops and asks the user to confirm overwrite, rename, or skip.
- Security warning when `--save-to` targets a tracked directory, since reports may contain Dependabot alert IDs, branch names, PR titles, and other operational signals.
- New `.gitignore` entry for `.github-health-reports/` so default-path reports stay out of version control.
- README "Saving reports" subsection with usage examples for `--save` and `--save-to`.
- Report-persistence section in `github-health/references/output-contract.md` defining flags, default path, filename safety, overwrite behavior, the `Saved to:` metadata line, and security warnings.
- Optional `Saved to:` line in `templates/full-health-report.md`.

### Notes

- Saving is purely a documentation/instruction-level change. No audit automation, no executable scripts, and no install-script behavior was added or modified.
- All 16 `SKILL.md` files retain their existing YAML frontmatter and structure.
- Saved reports are never auto-committed. The `.github-health-reports/` directory is gitignored by default; a tracked-directory `--save-to` requires the user to acknowledge a security warning.

## [0.1.1] — 2026-05-05

### Added

- Added `install.sh` for installing the GitHub Health Claude Skills pack as personal Claude Code skills under `~/.claude/skills`.
- Added README Quick Start instructions for fast install, audit-first install, and cloned-repository install.

### Notes

- The installer performs only local skill installation.
- The installer does not run audits, modify GitHub repositories, change shell profiles, require sudo, or install global dependencies.
- Skill content remains Markdown-only; `install.sh` is packaging/install convenience only.

## [0.1.0] — 2026-05-05

### Added

- Initial Markdown-only release of the `github-health-claude-skills` skill pack.
- Main orchestrator skill (`github-health/SKILL.md`) with mode parsing and routing.
- Shared reference files under `github-health/references/`:
  - `github-health-checklist.md`
  - `scoring-model.md`
  - `severity-model.md`
  - `output-contract.md`
  - `safety-rules.md`
  - `collection-guide.md`
- Specialized skills under `skills/`:
  - `github-health-full`
  - `github-health-actions`
  - `github-health-branches`
  - `github-health-pulls`
  - `github-health-issues`
  - `github-health-security`
  - `github-health-code-scanning`
  - `github-health-dependabot`
  - `github-health-secret-scanning`
  - `github-health-dependency-graph`
  - `github-health-docs`
  - `github-health-releases`
  - `github-health-permissions`
  - `github-health-linear`
  - `github-health-cleanup-plan`
- Auditor agent profiles under `agents/`.
- Reusable report templates under `templates/`.
- Illustrative example reports under `examples/`.
- Evaluation prompts and expected behavior reference under `evals/`.
- `README.md`, `SECURITY.md`, `LICENSE` (MIT), and this `CHANGELOG.md`.

### Notes

- This release is intentionally **Markdown-only**. There are no executable scripts, no automation, and no destructive defaults.
- All destructive operations are approval-gated and surfaced in the report's **Approval Required Before Destructive Actions** section.
- Linear integration is opt-in and treats GitHub as the technical source of truth and Linear as the operational source of truth.

## Roadmap

- **0.2.x — Command-guided.** Skills will suggest precise read-only commands the user can copy-paste; pasted output becomes structured evidence.
- **0.3.x — Optional automation.** Opt-in executable scripts limited to a strict read-only allowlist. Destructive operations remain manual.
