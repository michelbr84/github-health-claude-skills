# Security Policy

This repository ships **Claude Skills** — Markdown instructions that guide Claude to inspect GitHub projects and produce health reports. The skills themselves do not execute code. However, when Claude follows these instructions inside an environment that has live tools (GitHub CLI, GitHub MCP, Linear MCP, shell access), unsafe behavior in a skill could lead to destructive or unintended actions.

We treat skill-level safety issues with the same seriousness as code vulnerabilities.

## Scope

This policy covers issues in this repository, including:

- A skill that could cause destructive GitHub actions (delete, merge, close, dismiss, force-push, rewrite history, change settings) without explicit user approval.
- A skill that could leak secrets into a report, into a commit, or into another system.
- A skill that could mishandle credentials, tokens, environment variables, or `.env` files.
- A skill that could mislabel triaged or dismissed alerts as benign.
- A skill that could cause irreversible Linear changes.
- Eval prompts or examples that bake in unsafe defaults.
- Documentation that misrepresents the safety guarantees of a skill.

## Out of scope

- Bugs in third-party tools (GitHub CLI, GitHub MCP, Linear MCP, etc.) — please report those upstream.
- Generic prompt-injection research that does not affect this repository's instructions.
- Output quality issues that are not safety-relevant.

## Reporting a vulnerability

Please report suspected safety issues privately. Do **not** open a public GitHub issue with exploit details.

Preferred channels (in order):

1. A private security advisory on this repository ("Security" tab → "Report a vulnerability").
2. A direct message to a maintainer.

When reporting, include:

- A clear description of the issue.
- The skill, reference, or template involved.
- A minimal reproduction (a prompt or command that triggers the unsafe behavior).
- The impact you observed or expect.
- Any suggested mitigation.

We will acknowledge receipt within a reasonable time and coordinate a fix and disclosure timeline with you.

## Safety guarantees of the skills

Every skill in this repository is **read-only by default**. The full safety contract lives in [`github-health/references/safety-rules.md`](./github-health/references/safety-rules.md). Briefly:

- No destructive action runs without explicit user approval captured in the conversation.
- All proposed destructive actions appear under **Approval Required Before Destructive Actions** in the report.
- Secrets and tokens are never echoed back into the report. Only redacted references (e.g., `secret_<id>`) are used.
- Linear modifications are gated behind explicit approval.
- Branch protection, rulesets, and repository settings are inspected, never modified.

If you find a path that violates any of the above, treat it as a security issue and report it.

## Responsible use

This skill set is designed for maintainers operating on their own repositories or repositories they have permission to audit. Do not use it to scan repositories you do not have authorization to inspect.
