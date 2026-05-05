# Changelog

All notable changes to this project are documented in this file. The format is loosely based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to semantic versioning.

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
