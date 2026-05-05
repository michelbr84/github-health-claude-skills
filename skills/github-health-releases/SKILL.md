---
name: github-health-releases
description: "Audit tags, releases, changelog alignment, versioning consistency, release notes quality, artifacts, and release-history hygiene. Triggers on `/github-health releases <repo>` and requests like \"is our release process clean\", \"review release history\", or \"is the changelog aligned with tags\". For a full release-readiness check today (a composite of full + releases + security context), use `/github-health release-readiness <repo>` instead. Read-only; never creates, edits, or deletes releases or tags."
---

# github-health-releases

## When to trigger

- `/github-health releases <repo>`
- Questions about release history, versioning, changelog alignment, or release notes.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 13.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. List the most recent tags and releases.
2. For each recent release, capture: version, date, draft/prerelease state, asset count, release notes length and quality.
3. Cross-check tag → release alignment (every tag has a release? every release has a tag?).
4. Inspect versioning consistency (SemVer adherence; major/minor/patch logic).
5. Cross-check `CHANGELOG.md` against the most recent release.
6. Detect stale draft releases.
7. If applicable, cross-reference release notes with merged PRs since the previous release — flag PRs not mentioned.
8. Score the Releases / governance area (weight 5) per `scoring-model.md`.
9. Render a report focused on **Releases**.

## Evidence to collect

```
gh release list --limit 30
gh api repos/<owner>/<repo>/tags --jq '.[].name' | head -50
gh release view <latest> --json tagName,publishedAt,isDraft,isPrerelease,assets,body
git log --oneline <previous-tag>..<latest-tag>
```

## Red flags

- [HIGH] Latest tag has no associated release.
- [HIGH] Recent release notes are empty or only auto-generated noise.
- [HIGH] Versioning is inconsistent (major bump for a patch, minor without features, etc.).
- [MEDIUM] `CHANGELOG.md` has not been updated since two releases ago.
- [MEDIUM] Stale draft releases > 30 days old.
- [MEDIUM] Releases lack expected artifacts (binaries, source archives, signatures).
- [LOW] Release titles inconsistent across history.
- [INFO] No release in > 6 months on an active repository.

## Output format

Use the standard contract. Populate **Detailed Findings → Releases** in depth. Provide a release timeline mini-table: version, date, notes-quality (Good / Sparse / Empty), CHANGELOG aligned (Y/N).

## Safety rules

- Never create, edit, publish, or delete a release or tag.
- Recommendations to publish or unpublish a release go under **Approval Required Before Destructive Actions**.
- Recommendations to delete stale draft releases go under **Approval Required Before Destructive Actions** with a recovery note.
- Never propose force-tagging.

## When to escalate

- For broader release readiness (CI, security, docs), use `github-health-full release-readiness` instead.
- If versioning suggests breaking changes in patch releases, escalate to `github-health-docs` to fix the changelog.

## What not to do

- Do not invent release notes from PR titles. Recommend the user write them; do not pre-write them in the report.
- Do not classify a release as "ready" without evidence from CI and docs.
