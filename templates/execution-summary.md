# Execution Summary

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Iteration: <n> of <max>
Risk level: low | medium | high
Mode: default | --auto | --auto --auto-merge | --dangerously-skip-approvals --auto-merge
Saved to: <path if saved>           <!-- optional; include only when --save / --save-to was used -->

## Outcome

Status: success | stopped | aborted
Reason (if stopped/aborted): <stop-condition name from SKILL.md>

## Step-by-step log

1. Located source report: <path> (Score <n>, Status <GREEN|YELLOW|RED>).
2. Working tree clean: <yes/no>.
3. Default branch confirmed: <name> @ <SHA>; in sync with `origin/<name>`: <yes/no>.
4. Selected improvement: <title> (audit finding [<SEVERITY>] <title>).
5. Branch created: `health/ratchet-<YYYYMMDD>-<short-topic>` (from <default> @ <SHA>).
6. Files changed:
   - <path> (<added|modified|renamed>)
   - <path> (<added|modified|renamed>)
7. Local checks run:
   - <command> → <pass|fail|skipped — reason>
8. Commit(s):
   - <SHA> <subject>
9. Pushed to `origin/<branch>` at <UTC timestamp>. Force used: no. History rewritten: no.
10. PR opened: #<n> <title> — <URL>.
11. Actions:
    - <workflow> / <job>: <success|failure|cancelled|timed_out|action_required|pending|skipped>  <run URL>
    - <workflow> / <job>: <…>
12. Merge: <merged via squash @ <SHA>> | <not merged: <reason>>.
13. Verification audit: <path to fresh report> | <skipped: <reason>>.
14. Delta report: <path> | <not generated: <reason>>.

## Safety checks

- Force push attempted: no
- History rewrite attempted: no
- Branch deleted: no
- Required check overridden: no
- Secret detected in diff: no | yes (stopped — see below)
- Forbidden surface touched: no

If any line above says "yes", the loop must have stopped at that point.

## Time

Started: <UTC>
Ended:   <UTC>
Duration: <hh:mm:ss>

## Next step

- Continue to iteration <n+1>: <yes — next plan: <title>> | <no — <reason: --max-iterations reached / --target-score met / stop condition>>
- Recommended user action: <one line, e.g. "review PR #<n> manually" or "re-run with --risk-level medium">
