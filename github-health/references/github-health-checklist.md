# GitHub Health — Master Checklist

This is the exhaustive checklist used by the full audit. Specialized skills consume only the sections that apply to them.

Every item is one of:

- ✅ **Verified fact** — direct evidence available.
- ⚠️ **Likely conclusion** — inference from partial evidence; assumption stated explicitly.
- ❔ **Unverified** — could not access the data; record this explicitly rather than guessing.

---

## 1. Main branch and branch protection

- [ ] Default branch name (e.g., `main`).
- [ ] Default branch is up to date with the latest stable code.
- [ ] Default branch is protected.
- [ ] Branch protection or rulesets require pull requests.
- [ ] Required reviewers configured.
- [ ] Required status checks configured.
- [ ] "Require branches to be up to date before merging" enabled.
- [ ] Force pushes blocked on protected branches.
- [ ] Branch deletion blocked on protected branches.
- [ ] Linear history requirement (if applicable).
- [ ] Signed commits requirement (if applicable).
- [ ] Latest CI run on default branch is green.
- [ ] No unresolved merge conflicts on the default branch.

## 2. GitHub Actions / CI

- [ ] All workflows under `.github/workflows/` enumerated.
- [ ] Each workflow has a clear purpose and trigger set.
- [ ] Required status checks present in branch protection match real workflow jobs.
- [ ] No long-running queue or stuck runs.
- [ ] Recent failure rate per workflow.
- [ ] Flake hints (intermittent failures on the same job).
- [ ] Workflows pin actions by SHA or tag (no floating `@main`).
- [ ] `permissions:` block defined explicitly per workflow (least privilege).
- [ ] `GITHUB_TOKEN` default permissions set to `read` at the repo level.
- [ ] Secrets are referenced by name only (`${{ secrets.X }}`), not echoed.
- [ ] Artifacts and caches are used reasonably.
- [ ] Reusable workflows / composite actions consistent.
- [ ] No deprecated action versions in active use.
- [ ] Self-hosted runners (if any) reviewed for hardening.

## 3. Pull requests

- [ ] Number of open PRs.
- [ ] Oldest open PR age.
- [ ] PRs blocked by failing checks.
- [ ] PRs blocked by missing reviews.
- [ ] PRs with merge conflicts.
- [ ] PRs that are mergeable but checks pending — **do not recommend merge**.
- [ ] Stale PRs (no activity > N days).
- [ ] Draft PRs that are stale or abandoned.
- [ ] PRs without a linked issue or Linear ticket.
- [ ] PRs whose title or body could trigger auto-close (`Fixes #N`, `Closes #N`).
- [ ] PRs targeting non-default branches when they should target the default.

## 4. Branches

- [ ] Total branch count.
- [ ] Merged branches not yet deleted.
- [ ] Branches with no commits ahead of default ("ghost" branches).
- [ ] Stale branches (no activity > N days).
- [ ] Orphan branches (no associated PR).
- [ ] Long-lived feature branches diverging significantly from default.
- [ ] Naming convention adherence.
- [ ] Branch names that imply an open Linear/issue link (`feat/PROJ-123-foo`).

## 5. Issues

- [ ] Open issue count.
- [ ] Issues without labels.
- [ ] Issues without milestones (if milestones are used).
- [ ] Issues without assignees on important labels (e.g., `bug`, `security`).
- [ ] Stale issues (no activity > N days).
- [ ] Duplicate issues (heuristic).
- [ ] Bug issues without reproduction steps.
- [ ] Security-flavored issues filed publicly that should be private.

## 6. Security posture (umbrella)

- [ ] `SECURITY.md` present and current.
- [ ] Private vulnerability reporting enabled (if available).
- [ ] Code scanning enabled (CodeQL or other).
- [ ] Dependabot version updates enabled.
- [ ] Dependabot security updates enabled.
- [ ] Secret scanning enabled.
- [ ] Push protection enabled (if available).
- [ ] Workflow `permissions` are minimal.
- [ ] Branch protection enforced on default branch.
- [ ] No open malware alerts.
- [ ] No open secret scanning alerts.
- [ ] No critical Dependabot alerts open.
- [ ] CodeQL high-severity alerts triaged.

## 7. CodeQL / code scanning

- [ ] Code scanning enabled.
- [ ] Configured queries are appropriate for the language(s).
- [ ] Open alerts by severity (critical / high / medium / low).
- [ ] Dismissed alerts have a reason recorded.
- [ ] False-positive rate acceptable.
- [ ] Remediation tracked in issues or Linear when not auto-fixable.

## 8. Dependabot

- [ ] Version updates configured (`dependabot.yml`).
- [ ] Security updates enabled.
- [ ] Open Dependabot alerts by severity.
- [ ] Open Dependabot PRs status (mergeable, blocked, stale).
- [ ] Auto-merge policy is intentional (off by default).
- [ ] Lockfiles up to date.
- [ ] Manifest files consistent across the repo.
- [ ] No Dependabot **malware** alerts open.

## 9. Secret scanning

- [ ] Open secret scanning alerts (must be zero for GREEN).
- [ ] Bypass requests reviewed.
- [ ] Push protection on by default.
- [ ] `.env`, `.env.*`, `*.pem`, `*.key`, `*.crt` covered by `.gitignore`.
- [ ] No accidental commits of credentials in recent history (heuristic).
- [ ] Workflow logs are not echoing secrets.

## 10. Dependency graph and supply chain

- [ ] Dependency graph enabled.
- [ ] Manifest files identified per ecosystem.
- [ ] Lockfiles present where expected.
- [ ] Dependency review enabled on PRs.
- [ ] No abandoned (no-update-in-N-years) critical dependencies.
- [ ] Transitive dependencies reviewed for known issues.
- [ ] License risks flagged where present.

## 11. Permissions and access

- [ ] Collaborator list reviewed.
- [ ] Team access reviewed.
- [ ] GitHub Apps installed reviewed.
- [ ] Webhooks reviewed.
- [ ] Environment protections (deployment) reviewed.
- [ ] Default repository visibility appropriate.
- [ ] Outside collaborators kept to the minimum necessary.
- [ ] Token-bearing apps follow least privilege.

## 12. Documentation

- [ ] `README.md` present, current, and accurate.
- [ ] `SECURITY.md` present.
- [ ] `ROADMAP.md` present (if used).
- [ ] `CONTRIBUTING.md` present.
- [ ] `CHANGELOG.md` present and updated for last release.
- [ ] `CODEOWNERS` present and correct.
- [ ] Issue templates present.
- [ ] PR template present.
- [ ] License file present.
- [ ] Documentation references match current commands and behavior.

## 13. Releases and versioning

- [ ] Latest release identified.
- [ ] Latest tag matches latest release.
- [ ] Release notes meaningful.
- [ ] Versioning scheme consistent (SemVer recommended).
- [ ] Artifacts attached if applicable.
- [ ] Changelog updated for the release.
- [ ] No stale draft releases.

## 14. Linear / Roadmap sync (if Linear is available)

- [ ] PRs linked to Linear issues where expected.
- [ ] Linear "In Progress" issues have an active branch or open PR.
- [ ] Linear "Done" issues have merged PR evidence.
- [ ] Merged PRs updated their Linear issue.
- [ ] `ROADMAP.md` aligned with Linear initiatives, projects, or epics.
- [ ] Security follow-ups tracked in a private Linear project where applicable.
- [ ] No PR/branch text could accidentally auto-close a Linear issue.

## 15. Cross-cutting hygiene

- [ ] No leaked email or personal info in commits or files.
- [ ] No debugging code or commented-out blocks in main.
- [ ] No `TODO/FIXME/XXX` markers tied to security or correctness without an issue.
- [ ] License compliance for third-party assets.
- [ ] Repository description and topics meaningful.
