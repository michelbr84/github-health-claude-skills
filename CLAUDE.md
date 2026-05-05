# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A pure-Markdown **V1** Claude Skills package for auditing the health of any GitHub repository. There is no application code, no package manager, no build, no test runner, and no scripts to execute. Every artifact is a Markdown file consumed by Claude at skill-trigger time. Treat edits as edits to a *specification* — the contracts in `github-health/references/` are load-bearing.

V2 will add suggested read-only commands; V3 may add opt-in scripts. Do not introduce executable code into V1.

## High-level architecture

The repo is a layered skill system. Understanding the layering is the prerequisite for editing anything:

1. **Orchestrator** — [github-health/SKILL.md](github-health/SKILL.md). Parses `/github-health <mode?> <repo>`, picks a route, and produces the final report. It does not contain audit detail itself; it delegates.
2. **Specialized skills** — [skills/github-health-*/SKILL.md](skills/). One per audit dimension (actions, branches, pulls, issues, security, code-scanning, dependabot, secret-scanning, dependency-graph, docs, releases, permissions, linear, cleanup-plan) plus the catch-all [skills/github-health-full/SKILL.md](skills/github-health-full/SKILL.md). The orchestrator's routing table in [github-health/SKILL.md](github-health/SKILL.md) is the source of truth for which mode goes where.
3. **Shared references** — [github-health/references/](github-health/references/). Cross-cutting policies that *all* skills must respect:
   - [output-contract.md](github-health/references/output-contract.md) — required report sections, order, and finding micro-format.
   - [scoring-model.md](github-health/references/scoring-model.md) — area weights (Security 20, Actions 15, the rest 5–10), provisional bands (≥85 GREEN / 60–84 YELLOW / <60 RED), and override rules that can only push status *downward*.
   - [severity-model.md](github-health/references/severity-model.md) — BLOCKER/HIGH/MEDIUM/LOW/INFO definitions.
   - [safety-rules.md](github-health/references/safety-rules.md) — exhaustive list of forbidden-without-approval actions.
   - [collection-guide.md](github-health/references/collection-guide.md) — read-only commands for evidence gathering (local Git, `gh` CLI, GitHub MCP, UI paste-back).
   - [github-health-checklist.md](github-health/references/github-health-checklist.md) — exhaustive per-area checklist.
4. **Agent personas** — [agents/](agents/). Reusable voice/focus profiles a skill can compose (e.g., "actions-auditor", "security-auditor"). Skills reference them; they don't run on their own.
5. **Templates and examples** — [templates/](templates/) are copy-paste report shells; [examples/](examples/) are illustrative outputs and **must remain labeled as illustrative** (no claims of live data).
6. **Evals** — [evals/evals.json](evals/evals.json) maps prompts → expected route, with expected behaviors documented in [evals/expected-behavior.md](evals/expected-behavior.md).

The "big picture" rule: **specialized SKILL.md files stay small by delegating cross-cutting policy to the references**. If you find yourself restating the output contract, severity bands, or safety rules inside a specialized skill, link to the reference instead.

## SKILL.md anatomy

Every `SKILL.md` follows the same shape, in this order:

1. YAML frontmatter with `name` and `description` only.
2. Trigger / use cases.
3. Required inputs.
4. Step-by-step audit procedure (numbered).
5. Evidence to collect.
6. Red flags (what makes a finding non-GREEN).
7. Output format (link to `output-contract.md`, then list mode-specific subsections).
8. Safety rules (link to `safety-rules.md`, then list mode-specific destructive actions to approval-gate).
9. When to escalate to the full audit.
10. What not to do.

The `description` in frontmatter is what makes Claude pick the skill. Include both the slash-command form *and* the natural-language phrasings that should trigger it.

## Editing rules

- **Markdown only in V1.** No `.sh`, `.py`, `.js`, no executable scripts, no `package.json`. If you're tempted, the answer is "wait for V2/V3".
- **Read-only by default, destructive actions approval-gated.** Every recommendation that mutates state (delete branch, merge PR, close issue, dismiss alert, change protection, modify Linear, rotate secrets, push, force-push, history rewrite, manual workflow dispatch, edits to `.github/`) belongs under **Approval Required Before Destructive Actions** with a one-line rollback note. The full list is in [safety-rules.md](github-health/references/safety-rules.md) and is exhaustive for V1.
- **Don't break the output contract.** Section names and order in [output-contract.md](github-health/references/output-contract.md) are fixed. Narrow modes drop *Detailed Findings* subsections but keep the top-level layout (Executive Summary → Blockers → Attention Needed → Healthy Areas → Detailed Findings → Recommended Actions → Approval Required → Final Recommendation). Use the standard finding micro-format: `[SEVERITY] Title.` then `Evidence:` / `Impact:` / `Recommendation:`.
- **Don't break the scoring contract.** When adding an area, update the weights table in [scoring-model.md](github-health/references/scoring-model.md) so the total is still 100, and decide whether it deserves an override or floor rule. Status moves only downward via overrides; floors never upgrade a RED.
- **When adding a mode**, you must update three places consistently: the routing table in [github-health/SKILL.md](github-health/SKILL.md), the modes table in [README.md](README.md), and add an eval in [evals/evals.json](evals/evals.json) with an entry in [evals/expected-behavior.md](evals/expected-behavior.md).
- **Linear is operational truth, GitHub is technical truth.** Reading Linear is fine; writing to it is destructive and approval-gated. Don't infer Linear exists if there's no evidence — mark the section `Not applicable` and redistribute its weight per [scoring-model.md](github-health/references/scoring-model.md).
- **Evidence discipline.** Every finding is one of *verified fact*, *likely conclusion* (flag the assumption), or *unverified* (say so). Never invent evidence. Refer to secrets by ID, never by value.
- **Examples are illustrative.** Files in [examples/](examples/) describe a fictional state of `michelbr84/fluxswap-dex` (the canonical sample repository); keep the "illustrative" framing intact when editing.

## No build / test / lint

There is nothing to run. Validation is by reading: open the changed `SKILL.md`, walk it against [output-contract.md](github-health/references/output-contract.md), [safety-rules.md](github-health/references/safety-rules.md), and the SKILL.md anatomy above. If you change a routing or scoring rule, also re-check the relevant entries in [evals/evals.json](evals/evals.json) and [evals/expected-behavior.md](evals/expected-behavior.md) so the eval scenarios still match the new behavior.
