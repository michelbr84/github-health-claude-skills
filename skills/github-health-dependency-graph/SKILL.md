---
name: github-health-dependency-graph
description: Audit the dependency graph, dependency review, manifest and lockfile coverage, transitive risk, abandoned dependencies, and license signals. Triggers on /github-health dependency-graph <repo> and on requests about supply chain, SBOM, or transitive dependencies. Read-only; never modifies manifests or lockfiles.
---

# github-health-dependency-graph

## When to trigger

- `/github-health dependency-graph <repo>`
- Questions about supply-chain risk, SBOM, transitive dependencies, abandoned packages, or license posture.

## Required inputs

- GitHub repository URL.

## Reference files

- `github-health/references/github-health-checklist.md` — Section 10.
- `github-health/references/scoring-model.md`
- `github-health/references/severity-model.md`
- `github-health/references/output-contract.md`
- `github-health/references/safety-rules.md`
- `github-health/references/collection-guide.md`

## Procedure

1. Identify ecosystems present (Node, Python, Rust, Go, Java, Ruby, .NET, etc.) by detecting manifest files.
2. For each ecosystem, confirm a corresponding lockfile is present.
3. Confirm the dependency graph is enabled in repository settings.
4. Inspect `.github/workflows/*` for `dependency-review-action` on PRs.
5. Spot-check transitive risk:
   - Heavily depended-upon packages (e.g., common transitive utilities).
   - Packages whose latest release is > 2 years old (potential abandonment).
   - Packages with known migration churn (e.g., `request`, `node-sass`, `moment` in JS).
6. Spot-check license posture: presence of incompatible licenses (e.g., GPL pulled into a permissive-licensed product).
7. Score the Dependencies area (weight 10) per `scoring-model.md`.
8. Render a report focused on **Dependencies**.

## Evidence to collect

- Manifest files: `package.json`, `Cargo.toml`, `pyproject.toml`, `requirements*.txt`, `go.mod`, `pom.xml`, `build.gradle`, `Gemfile`, `*.csproj`.
- Lockfiles: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `Cargo.lock`, `poetry.lock`, `Pipfile.lock`, `go.sum`, `Gemfile.lock`.
- `dependency-review-action` usage in workflows.

```
ls -la package*.json pnpm-lock.yaml yarn.lock Cargo.* pyproject.toml requirements*.txt poetry.lock Pipfile* go.* Gemfile* *.csproj 2>/dev/null
grep -nrE "dependency-review-action" .github/workflows 2>/dev/null
```

## Red flags

- [HIGH] Manifest exists without a corresponding lockfile.
- [HIGH] No `dependency-review-action` configured on PRs for a serious project.
- [HIGH] Lockfile is months out of date relative to manifest.
- [MEDIUM] Critical dependency has had no release in > 2 years.
- [MEDIUM] License conflict detected (heuristic).
- [MEDIUM] Many ecosystems but only some are tracked in `dependabot.yml`.
- [LOW] Inconsistent package manager (`yarn.lock` and `package-lock.json` both present).

## Output format

Use the standard contract. Populate **Detailed Findings → Dependencies** in depth, broken down by ecosystem.

## Safety rules

- Never modify manifests or lockfiles.
- Never auto-bump dependencies.
- Never propose deleting a manifest or lockfile to "clean up".
- Recommendations to upgrade or replace a dependency are listed as manual Do-This-Week or Do-Later items, with rationale; if the dependency is end-of-life, escalate to HIGH.

## When to escalate

- If supply-chain alerts are actively open, escalate to `github-health-dependabot` and `github-health-security`.
- If license risk is non-trivial, recommend a separate legal/license review (out of scope here).

## What not to do

- Do not invent abandonment signals; cite the last release date and registry source where possible.
- Do not confuse "latest" with "greatest" — security patches may live on older lines.
