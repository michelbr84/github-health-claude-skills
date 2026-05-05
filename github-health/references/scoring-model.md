# Scoring Model

Every audit produces a single **Health Score** between 0 and 100 and an **Overall Status**: `GREEN`, `YELLOW`, or `RED`.

The score is computed by summing weighted area scores. The status is then **overridden downward** if any of the override rules apply.

## Status definitions

- **GREEN** — healthy. No blockers. Only minor improvements remain.
- **YELLOW** — usable but needs attention. At least one HIGH severity finding, or several MEDIUMs, or a missing-but-not-critical safeguard.
- **RED** — blocked, risky, insecure, or unreliable. At least one BLOCKER, or any active override rule below.

## Area weights

| Area | Weight |
| --- | --- |
| Main branch and branch protection | 10 |
| Actions / CI | 15 |
| Pull requests | 10 |
| Branch hygiene | 10 |
| Security alerts | 20 |
| Dependencies | 10 |
| Documentation | 10 |
| Linear / roadmap sync | 10 |
| Releases / governance | 5 |
| **Total** | **100** |

## Per-area scoring guidance

For each area, score from **0 to its weight**:

- Full weight: area is healthy with only minor improvements.
- ~75% of weight: area is usable but has at least one HIGH severity finding.
- ~50% of weight: area has multiple HIGHs or a structural gap.
- ~25% of weight: area has BLOCKERs but is partially functional.
- 0: area is broken, missing, or unverifiable in a way that is itself a finding.

If an area is **not applicable** (e.g., Linear is not in use), redistribute its weight proportionally across the remaining areas. State the redistribution explicitly in the report.

## Override rules (status cannot be GREEN)

The status **cannot be GREEN** if any of the following are true:

1. The default branch CI is currently **red**.
2. There is at least **one open secret scanning alert**.
3. There is at least **one open malware alert**.
4. There is at least **one open critical Dependabot alert**.
5. There are **untriaged high-severity CodeQL alerts**. (Triaged alerts with a clear remediation plan do not trigger this rule but still affect the score.)
6. The repository is a serious project (active development, multiple contributors, or external users) and **branch protection on the default branch is missing**.
7. A PR has been recommended for merge while **required checks are still pending**. The audit must not recommend merge in this state.
8. **Linear says "Done"** for an issue but **no merged PR evidence** exists in GitHub. The status must include roadmap/process drift and cannot be GREEN.
9. The repository **has no `SECURITY.md`** and the security posture cannot otherwise be demonstrated. (Security posture cannot be excellent without it; status drops at least to YELLOW.)

## Status floor rules

When the override doesn't push to RED but raises concern:

- Missing branch protection on a serious project → at least YELLOW.
- Missing `SECURITY.md` → at least YELLOW.
- Stale lockfiles or out-of-date manifests → at least YELLOW.
- Linear/Roadmap drift detected → at least YELLOW.

## Computing the final status

1. Compute the area scores using the weights table.
2. Sum to get the raw `Health Score (0–100)`.
3. Determine a provisional status from the score:
   - 85–100 → GREEN
   - 60–84 → YELLOW
   - 0–59 → RED
4. Apply override rules. The status can move only **downward**, never upward.
5. Apply status floor rules. Move upward to the floor only if the provisional was higher; never use a floor to upgrade a RED to YELLOW.
6. Record both the score and the status in the report.

## Worked example

A repository scores: Main 9, Actions 10, PRs 8, Branches 6, Security 18, Deps 8, Docs 7, Linear 5, Releases 4 → **75 / 100**.

Provisional status: YELLOW.

There is one open secret scanning alert → override rule 2 applies → cannot be GREEN. Already YELLOW; status remains **YELLOW**.

If main CI were also red, override rule 1 would apply and status becomes **RED** regardless of the score.
