#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/deploy-common.sh"
check_main
if [ -n "$(git status --porcelain)" ]; then
  echo 'Stopped: there are unpublished edits. Ask Codex to preserve them before rolling back.' >&2; exit 1
fi
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
  echo 'Stopped: local main must match GitHub main before rolling back.' >&2; exit 1
fi
if ! git revert --no-edit HEAD; then
  git revert --abort || true
  echo 'Rollback could not be applied cleanly. Nothing was pushed; ask Codex to resolve it.' >&2; exit 1
fi
# A failed build leaves the revert commit local for inspection, never pushed.
build_site
push_and_wait
