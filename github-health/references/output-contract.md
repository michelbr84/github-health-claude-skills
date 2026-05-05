# Output Contract

Every audit report — regardless of mode — must follow the structure below. Specialized skills may omit subsections that do not apply, but the top-level layout stays the same.

## Required structure

```
# GitHub Health Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: <full | quick | standard | deep | actions | branches | pulls | issues | security |
       code-scanning | dependabot | secret-scanning | dependency-graph | docs |
       releases | permissions | linear | cleanup-plan | pre-merge | post-merge |
       release-readiness>
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100
Saved to: <path>            # optional — present only when the report was persisted to disk

## Executive Summary

A 3–6 sentence plain-English summary of overall health, headline risks, and the single
most important next action. No bullets, no jargon, no hedging.

## Blockers

Each blocker is a BLOCKER-severity finding that must be addressed before the repository
is considered healthy. Use the standard finding micro-format. If there are none, write
"None." explicitly.

## Attention Needed

HIGH and MEDIUM-severity findings. Group by area when there are many. If none, write
"None." explicitly.

## Healthy Areas

A short list of what is working well. Helps the reader understand what not to break.

## Detailed Findings

### Main Branch
### Actions
### Pull Requests
### Branches
### Issues
### Security
### Dependencies
### Documentation
### Releases
### Linear / Roadmap Sync

For each subsection, list findings using the standard finding micro-format:

- [SEVERITY] Short title.
  Evidence: <verifiable observation>.
  Impact: <what this could cause>.
  Recommendation: <next step or action>.

If a subsection is `Not applicable`, say so explicitly with one line of justification.

## Recommended Actions

### Do Now

Concrete, non-destructive next steps that should be done today. Each item is one
imperative sentence.

### Do This Week

Concrete next steps to schedule within the week.

### Do Later

Improvements and hygiene items.

## Approval Required Before Destructive Actions

Any action that would mutate state goes here. Each item must include:

- The exact action (e.g., "delete branch `feature/x` after final merge confirmation").
- Why it is necessary.
- A one-line rollback or recovery note.

If there are none, write "None." explicitly.

## Final Recommendation

One paragraph. State the single most important thing the maintainer should do next, the
expected outcome, and whether to re-run a deeper audit afterward.
```

## Rules

1. Do not deviate from the section names or order.
2. Do not collapse `Approval Required Before Destructive Actions` into the regular action lists. It must remain a separate, visible block.
3. If `Mode` is narrow, keep only the relevant Detailed Findings subsections, but always keep `Executive Summary`, `Blockers`, `Attention Needed`, `Healthy Areas`, `Recommended Actions`, `Approval Required Before Destructive Actions`, and `Final Recommendation`.
4. Use the finding micro-format consistently:
   ```
   - [SEVERITY] Title.
     Evidence: …
     Impact: …
     Recommendation: …
   ```
5. Quote evidence where helpful (e.g., a workflow file path, a commit SHA, a PR number) but never quote secret values or tokens. Refer to secrets by ID only.
6. If a finding is unverified, mark it explicitly: `Evidence: Unverified — could not access <data>.`
7. Keep prose tight. Long lists belong in the appropriate subsection, not the executive summary.

## Report persistence

Reports are produced for chat consumption by default. Persisting a report to disk is **optional** and is controlled by save flags on the invoking command.

### Save flags

| Flag | Effect |
| --- | --- |
| *(none)* | Print report in chat only. Do not write any file. |
| `--save` | Print report in chat **and** save a Markdown copy to the default reports directory. |
| `--save-only` | Write the Markdown report to the default directory. In chat, print only a short summary (status, score, blocker count, top action) and the saved path. |
| `--save-to <path>` | Write the Markdown report to the user-supplied path. Create parent directories if they do not exist. |

The flags are mutually exclusive. If more than one is supplied, ask the user which to use rather than guessing.

### Default save path

When `--save` or `--save-only` is used, write to:

```
.github-health-reports/<owner>-<repo>/<YYYY-MM-DD>-<mode>-health-report.md
```

Rules for the default path:

- `<owner>-<repo>` joins the GitHub owner and repo names with a single hyphen, lower-cased (e.g., `michelbr84-fluxswap-dex`). This guarantees uniqueness when two owners share a repo name.
- `<YYYY-MM-DD>` is the value of the report's `Date:` field, not the local clock.
- `<mode>` is the resolved mode (`quick`, `full`, `actions`, etc.). For composite modes (`pre-merge`, `post-merge`, `release-readiness`), use the composite name as a single token.
- The `.github-health-reports/` prefix is intentionally dot-prefixed so it is hidden in default `ls` output and is gitignored by this repository.

Example:

```
.github-health-reports/michelbr84-fluxswap-dex/2026-05-05-quick-health-report.md
```

### Filename safety

If `<owner>` or `<repo>` contains characters that are unsafe for the local filesystem, replace them with `-`. Never path-traverse: reject any computed path containing `..` segments or absolute prefixes inside the default directory.

### Overwrite behavior

Saving is **non-overwriting**. Before writing:

1. Check whether the target path already exists.
2. If it does, **stop and ask the user explicitly** whether to overwrite, save under a new name, or skip saving. Do not write a `.bak`, do not append a numeric suffix automatically, and do not silently pass through.
3. If the user approves overwrite, treat it as a destructive write — record the chosen path in the *Saved to:* metadata line, but do not list the overwrite under *Approval Required Before Destructive Actions* (it does not change repository or upstream state).

This rule applies equally to the default path (so a same-day re-run on the same mode does not clobber an earlier report) and to `--save-to <path>`.

### `Saved to:` metadata

When a report is saved, render an additional header line directly under `Health Score:`:

```
Saved to: <repo-relative-or-absolute-path>
```

Use a repo-relative path when the save target is inside the current working tree; otherwise use an absolute path. When the report is not saved, omit the line entirely — do not write `Saved to: (not saved)` or similar.

### Security warnings

A generated report may contain:

- Open Dependabot alert IDs and affected packages.
- Open code scanning and secret scanning summaries.
- Branch names, PR titles, contributor logins, and internal repository topology.
- Operational notes about CI, environments, and roadmap items.

Therefore:

- **Never auto-commit** a saved report. Saving writes the file to disk; it does not stage, commit, or push it.
- **The default `.github-health-reports/` directory is gitignored** at the repository root. Refer to `.gitignore` for the exact entry.
- **If the user supplies `--save-to <path>` inside a tracked location** (anywhere not matched by `.gitignore` — for example `docs/`, `internal/`, or the project root), warn the user once *before* writing: the report may contain sensitive security information; if they then `git add` the file, it could enter version control. Proceed with the save only after the user acknowledges the warning.
- **Never paste secret values** into a saved report (this is unchanged from rule 5 above; secrets are referred to by ID only regardless of persistence).
