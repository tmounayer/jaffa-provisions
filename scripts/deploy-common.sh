#!/usr/bin/env bash
# Shared by publish and rollback. HTTPS only; never disables certificate checks.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

check_main() {
  if [ "$(git branch --show-current)" != main ]; then
    echo 'Stopped: switch to main before publishing or rolling back.' >&2; exit 1
  fi
  if [ -d "$(git rev-parse --git-path rebase-merge)" ] || [ -d "$(git rev-parse --git-path rebase-apply)" ] || [ -f "$(git rev-parse --git-path MERGE_HEAD)" ] || [ -f "$(git rev-parse --git-path REVERT_HEAD)" ]; then
    echo 'Stopped: finish the current Git operation first.' >&2; exit 1
  fi
  git fetch origin main || { echo 'Stopped: could not reach GitHub. Check the GitHub login and connection.' >&2; exit 1; }
  git merge-base --is-ancestor origin/main HEAD || {
    echo 'Stopped: GitHub has changes missing locally. Ask Codex to integrate them first.' >&2; exit 1;
  }
}

build_site() {
  if ! npm run build; then
    echo 'Build failed. Nothing was pushed. Ask Codex to fix the error and try again.' >&2; exit 1
  fi
}

wait_for_live() {
  local sha="$1" url='https://jaffaprovisions.com' page remaining
  local deadline=$((SECONDS + 300))
  echo "Waiting for Cloudflare to serve build $sha at $url (up to 5 minutes)..."
  while (( SECONDS < deadline )); do
    remaining=$((deadline - SECONDS))
    if (( remaining > 10 )); then remaining=10; fi
    if page=$(curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --connect-timeout 5 --max-time "$remaining" -H 'Cache-Control: no-cache' "$url/?build-check=$sha" 2>/dev/null); then
      if printf '%s' "$page" | node -e '
        let html=""; process.stdin.on("data", chunk => html += chunk);
        process.stdin.on("end", () => {
          const tags=html.match(/<meta\b[^>]*>/gi) || [];
          const found=tags.some(tag => /\bname=["\x27]build-id["\x27]/i.test(tag) && new RegExp("\\bcontent=[\"\x27]" + process.argv[1] + "[\"\x27]", "i").test(tag));
          process.exit(found ? 0 : 1);
        });' "$sha"; then
        echo "Live: $url (build $sha)"; return 0
      fi
    fi
    remaining=$((deadline - SECONDS))
    if (( remaining <= 0 )); then break; fi
    if (( remaining > 15 )); then remaining=15; fi
    sleep "$remaining"
  done
  echo "Timed out: GitHub received $sha, but the live site did not confirm it within 5 minutes. Check the Cloudflare Pages deployment dashboard and custom domain status. Do not assume the update is live." >&2
  return 1
}

push_and_wait() {
  local sha
  sha=$(git rev-parse --short=7 HEAD)
  git push origin main || { echo 'Push failed. The commit is saved locally; ask Codex to resolve the GitHub error.' >&2; exit 1; }
  wait_for_live "$sha"
}
