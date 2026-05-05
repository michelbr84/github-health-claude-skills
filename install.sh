#!/usr/bin/env bash
#
# github-health-claude-skills — personal installer (V1).
#
# Copies the skill pack into ~/.claude/skills. Read-only with respect to
# anything outside ~/.claude/skills. No sudo. No global dependencies. Does
# not modify shell profiles. Does not run Claude Code. Existing skills of
# the same name are renamed to a timestamped backup before being replaced.
#
# Usage:
#   1) From a cloned repository:
#        bash install.sh
#   2) Through curl:
#        curl -fsSL https://raw.githubusercontent.com/michelbr84/github-health-claude-skills/main/install.sh | bash

set -euo pipefail

REPO_OWNER="michelbr84"
REPO_NAME="github-health-claude-skills"
REPO_BRANCH="main"
TARBALL_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${REPO_BRANCH}.tar.gz"

CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"

# Skill folders to install. The orchestrator lives at the repo root under
# `github-health/`; specialized skills live under `skills/`.
SKILL_NAMES=(
  "github-health"
  "github-health-full"
  "github-health-actions"
  "github-health-branches"
  "github-health-pulls"
  "github-health-issues"
  "github-health-security"
  "github-health-code-scanning"
  "github-health-dependabot"
  "github-health-secret-scanning"
  "github-health-dependency-graph"
  "github-health-docs"
  "github-health-releases"
  "github-health-permissions"
  "github-health-linear"
  "github-health-cleanup-plan"
)

# The orchestrator is the one skill not under skills/.
skill_source_subpath() {
  local name="$1"
  if [ "$name" = "github-health" ]; then
    printf '%s' "github-health"
  else
    printf '%s' "skills/${name}"
  fi
}

log() { printf '%s\n' "$*"; }
err() { printf 'install.sh: error: %s\n' "$*" >&2; }

# Decide whether we are running from a cloned repository or piped via curl.
# In the cloned case, BASH_SOURCE[0] points to a real file next to the skill
# tree. In the curl case, BASH_SOURCE[0] is unset or a non-file (stdin), so
# we download the repository tarball into a temporary directory.
detect_source_dir() {
  local script_path="${BASH_SOURCE[0]:-}"
  local script_dir=""
  if [ -n "$script_path" ] && [ -f "$script_path" ]; then
    script_dir="$(cd "$(dirname "$script_path")" 2>/dev/null && pwd)" || script_dir=""
  fi

  if [ -n "$script_dir" ] && [ -f "$script_dir/github-health/SKILL.md" ]; then
    SOURCE_DIR="$script_dir"
    MODE="local"
    return 0
  fi

  MODE="curl"
  for tool in curl tar mktemp; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      err "missing required tool: $tool"
      exit 1
    fi
  done

  TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t gh-health-install)"
  trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

  log "==> Downloading ${REPO_OWNER}/${REPO_NAME}@${REPO_BRANCH}"
  if ! curl -fsSL "$TARBALL_URL" -o "$TMP_DIR/repo.tar.gz"; then
    err "failed to download $TARBALL_URL"
    exit 1
  fi
  if ! tar -xzf "$TMP_DIR/repo.tar.gz" -C "$TMP_DIR"; then
    err "failed to extract repository tarball"
    exit 1
  fi

  SOURCE_DIR="$TMP_DIR/${REPO_NAME}-${REPO_BRANCH}"
  if [ ! -d "$SOURCE_DIR" ]; then
    err "expected extracted directory not found: $SOURCE_DIR"
    exit 1
  fi
}

install_skill() {
  local name="$1"
  local subpath
  subpath="$(skill_source_subpath "$name")"
  local src="${SOURCE_DIR}/${subpath}"
  local dst="${CLAUDE_SKILLS_DIR}/${name}"

  if [ ! -d "$src" ]; then
    err "source missing: $src"
    return 1
  fi
  if [ ! -f "$src/SKILL.md" ]; then
    err "source skill missing SKILL.md: $src"
    return 1
  fi

  if [ -e "$dst" ]; then
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    local backup="${dst}.backup-${ts}"
    log "  backup ${name} -> $(basename "$backup")"
    mv "$dst" "$backup"
  fi

  cp -R "$src" "$dst"

  if [ ! -f "$dst/SKILL.md" ]; then
    err "verification failed: $dst/SKILL.md not found after copy"
    return 1
  fi

  log "  installed ${name}"
}

main() {
  detect_source_dir

  log "==> Installing ${REPO_NAME}"
  log "    source: $SOURCE_DIR"
  log "    target: $CLAUDE_SKILLS_DIR"
  log "    mode:   $MODE"

  mkdir -p "$CLAUDE_SKILLS_DIR"

  for name in "${SKILL_NAMES[@]}"; do
    install_skill "$name"
  done

  log ""
  log "==> Installed ${#SKILL_NAMES[@]} skills."
  log ""
  log "Try a first audit in Claude Code:"
  log "  /github-health quick https://github.com/michelbr84/fluxswap-dex"
  log "  /github-health actions https://github.com/michelbr84/fluxswap-dex"
  log ""
  log "If Claude Code was already running and ~/.claude/skills did not"
  log "previously exist, restart Claude Code so the new skill directory is"
  log "picked up."
}

main "$@"
