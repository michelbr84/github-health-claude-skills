# GitHub Health Report

Repository: <owner>/<repo>
Date: YYYY-MM-DD
Mode: full
Overall Status: GREEN / YELLOW / RED
Health Score: 0-100

## Executive Summary

<3–6 sentence plain-English summary of overall health, headline risks, and the single most important next action.>

## Blockers

- [BLOCKER] <Title>.
  Evidence: <verifiable observation>.
  Impact: <what this could cause>.
  Recommendation: <next step or action>.

(If none, write `None.`)

## Attention Needed

- [HIGH] <Title>. Evidence/Impact/Recommendation.
- [MEDIUM] <Title>. Evidence/Impact/Recommendation.

(If none, write `None.`)

## Healthy Areas

- <Short bullet for each area that is working well.>

## Detailed Findings

### Main Branch

- [SEVERITY] Default branch: `<name>`. Latest CI: <green/red>. Branch protection: <on/off, with summary>.

### Actions

- [SEVERITY] Workflow `<file>`. Failure rate: <%>. Permissions: <ok/over-broad>. Pinning: <ok/floating>.

### Pull Requests

- [SEVERITY] PR `#<n>` `<title>`. Class: <Ready/Blocked-by-checks/Blocked-by-review/Conflict/Stale/Abandoned>. Recommendation: <…>.

### Branches

- [SEVERITY] Branch `<name>`. Class: <Active/Merged-undeleted/Stale/Orphan/Long-lived>. Recommendation: <…>.

### Issues

- [SEVERITY] <Group title — e.g., "Issues missing labels">. Count: <n>. Recommendation: <…>.

### Security

- [SEVERITY] Code scanning: <open by severity>. Dependabot: <open by severity>. Secret scanning: <open count>. Push protection: <on/off>. SECURITY.md: <present/missing>.

### Dependencies

- [SEVERITY] <Ecosystem>. Manifest: <…>. Lockfile: <present/missing>. Notable risks: <…>.

### Documentation

- [SEVERITY] <File>. Present/Missing. Last updated: <date>. Judgment: <…>. Recommendation: <…>.

### Releases

- [SEVERITY] Latest release: `<tag>` (<date>). Notes quality: <Good/Sparse/Empty>. CHANGELOG aligned: <Y/N>.

### Linear / Roadmap Sync

- [SEVERITY] <Finding>. (Or `Not applicable — Linear not in use.`)

## Recommended Actions

### Do Now

- <Imperative sentence, non-destructive.>

### Do This Week

- <Imperative sentence.>

### Do Later

- <Imperative sentence.>

## Approval Required Before Destructive Actions

- Action: <exact command or operation>.
  Target: <branch / PR / issue / alert / file>.
  Why: <one line>.
  Rollback: <one line>.

(If none, write `None.`)

## Final Recommendation

<One paragraph stating the single most important next step, the expected outcome, and whether to re-run a deeper audit afterward.>
