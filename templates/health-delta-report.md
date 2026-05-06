# Health Delta Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Iteration: <n> of <max>
Improvement: <short title>
Saved to: <path if saved>           <!-- optional; include only when --save / --save-to was used -->

## Reports compared

Previous report: <path> (<mode>, <YYYY-MM-DD>)
New report:      <path> (<mode>, <YYYY-MM-DD>) | **estimated** — no fresh report available

## Score change

| | Previous | New | Delta |
| --- | --- | --- | --- |
| Health score | <n> / 100 | <n> / 100 | <+/-n> |
| Overall status | GREEN/YELLOW/RED | GREEN/YELLOW/RED | <unchanged \| improved \| regressed> |

If the new score is **estimated** (no fresh audit available yet), every row above is labeled `(estimated)` and the final recommendation must say so.

## Findings resolved

- [<SEVERITY>] <title> — <one-line note on how this branch addressed it>
- ...

(If none, write `None.`)

## Findings unchanged

- [<SEVERITY>] <title> — <one-line note: deferred / out of risk-level scope / next iteration candidate>
- ...

## Findings newly discovered

- [<SEVERITY>] <title> — <one-line note: introduced by which file/area; whether the loop should stop>
- ...

(If any new BLOCKER appears, the loop must stop and the user must be notified.)

## Branch and PR

Branch: `health/ratchet-<YYYYMMDD>-<short-topic>`
Commits:
- <SHA> <subject>
PR: #<n> <title> — <URL>
Base → Head: <default> ← `health/ratchet-<YYYYMMDD>-<short-topic>`

## GitHub Actions result

| Workflow / Job | Conclusion | Run URL |
| --- | --- | --- |
| <workflow> / <job> | success/failure/… | <url> |
| ... | | |

All required checks green: yes | no
Mergeable / clean: yes | no

## Merge result

- merged via squash at <SHA> on <UTC>
- not merged: <reason — e.g., required check failed, --auto-merge not present, conflict>

## Next recommended improvement

Suggested next iteration target: <short title>
Audit finding it would address: [<SEVERITY>] <title>
Risk level needed: <low|medium|high>
Predicted score impact: <+n>

If `--max-iterations` or `--target-score` halted the loop, state that explicitly here so the user knows why we stopped even though more improvements remain.

## Verification

- Score change source: verified by fresh `quick` audit | **estimated** (no fresh audit)
- Forbidden surfaces touched: no
- Hard safety rules violated: no
- Secrets exposed in any artifact: no

If any of the three above is "yes", the report is invalid and the run must be treated as a safety incident.
