#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/deploy-common.sh"
check_main
build_site
# The first build validates edits before they become a commit.
git add --all
if git diff --cached --quiet; then
  echo 'Nothing to commit. Continuing to push and verify the live site.'
else
  git commit -m "Site update $(date '+%Y-%m-%d %H:%M')"
  # Rebuild with the new commit SHA, matching Cloudflare's build.
  build_site
fi
push_and_wait
