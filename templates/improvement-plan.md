# Improvement Plan

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Iteration: <n> of <max>
Risk level: low | medium | high
Source report: <path to the audit report this plan was derived from>
Saved to: <path if saved>           <!-- optional; include only when --save / --save-to was used -->

## Selected improvement

Title: <short noun phrase, e.g. "Add LICENSE">
Audit finding addressed: [<SEVERITY>] <finding title from the source report>
Why this raises the score: <one or two sentences referencing the relevant scoring area>

## Predicted score impact

Previous score: <n> / 100
Predicted score after merge: <n> / 100 (estimate — confirmed only by a fresh quick audit)
Areas affected: <e.g. Documentation +2, Security floor lifted from YELLOW>

## Files to touch

- <path> — <what changes (added | modified | renamed)>
- <path> — <what changes>

(Keep the list minimal. One improvement per branch.)

## Risks and unknowns

- <risk 1: e.g. "CONTRIBUTING.md style mismatch with repo voice">
- <risk 2: e.g. "CodeQL workflow may add a few minutes to first CI run">

If any risk maps to a forbidden surface (branch protection, secrets, weakening security), STOP — this plan must not be executed.

## Branch and commit

Branch: `health/ratchet-<YYYYMMDD>-<short-topic>`
Commit subject: `chore(health): <short improvement>` | `docs(health): <short improvement>` | `ci(security): <short improvement>`
Commit body summary: <one paragraph explaining why and which audit finding it addresses>

## PR preview

Base: <default branch>
Head: `health/ratchet-<YYYYMMDD>-<short-topic>`
Title: <Conventional Commits subject>
Body summary:
- Addresses: [<SEVERITY>] <audit finding>
- Source report: <path>
- Planned delta report: <path>

## Approval

- Mode: default approval-gated | --auto | --auto + --auto-merge | --dangerously-skip-approvals
- Awaiting user approval? Yes | No (already authorized at command level)

## Next iteration candidate (if loop continues)

<one-line note on what the *next* improvement is likely to be, so the user can stop early if they prefer a different sequence>
