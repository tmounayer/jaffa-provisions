# Jaffa Provisions

Static Astro marketing site. Minimal Astro template, TypeScript content, plain scoped styles, one shared layout. Astro is the only direct dependency. The XML sitemap uses a static Astro endpoint, so no sitemap integration is needed. No server adapter, Functions, CMS, database, analytics, external fonts, or client-side production scripts.

## Run locally

Use Node 24 LTS and npm. `.node-version` selects major 24 for Cloudflare. On this Mac Homebrew installed Node at `/opt/homebrew/opt/node@24/bin`; if npm is missing from the agent shell, prepend that directory and `/opt/homebrew/bin` to PATH for the command.

```sh
npm ci
npm run dev
npm run build
npm run preview
```

Use the URL printed by Astro. Production output goes to `dist`. `astro.config.mjs` pins `vite.tsconfig` to this project's `tsconfig.json`; without it, Vite 8's rolldown resolver auto-discovers any `tsconfig.json` in a parent directory, so a nested checkout (for example a Git worktree inside another checkout that has no `node_modules`) fails with `Tsconfig not found astro/tsconfigs/strict`. The lockfile pins the tested dependencies. Astro 7.3.2 was the latest stable version installed from the registry during setup. No GitHub Actions.

## Edit or add a page

- `src/content/site.ts`: all editable words, contact fields, link destinations, image paths, alt text, theme, metadata and 404 text. Extend this typed object for future page content.
- `public/images`: locally served imagery. The starter JPG is an AI-generated editorial still life, not a product photograph or a claim about current inventory.
- `src/pages/index.astro`: homepage layout and scoped styles. Section images alternate sides on desktop.
- `src/layouts/Layout.astro`: shared head, header, footer and base styles.
- `src/pages/404.astro`: not-found page, with text from site.ts.
- `src/pages/sitemap.xml.ts`: explicit route list. Add each new public route here; omit 404.

To add a page, add its copy to site.ts, create `src/pages/about.astro` (for `/about/`), import Layout and site, and add the route to the sitemap. Preview and build. All optional contacts are omitted when blank. Instagram expects a full HTTPS profile URL. Signup links to a supplied form URL and is hidden when disabled or its URL is blank. Theme font uses one system font family with a generic fallback.

## GitHub and Cloudflare Pages

Existing repository: https://github.com/tmounayer/jaffa-provisions. It is PUBLIC per the owner's explicit earlier choice and has not been made private automatically. The pasted spec's private-repo requirement conflicts with that choice; owner can change visibility if desired.

The Cloudflare Pages project `jaffa-provisions` is connected to this GitHub repository. Its assigned URL is https://jaffa-provisions.pages.dev. Build settings:

| Setting | Value |
| --- | --- |
| Framework preset | Astro |
| Production branch | main |
| Build command | npm run build |
| Build output directory | dist |
| Root directory | repository root (leave blank) |
| Node | 24 via .node-version |

Do not add a server adapter, Worker, credit card, analytics, or paid features. Cloudflare rebuilds on pushes to main. Account connection, deployment and HTTPS verification are complete.

## Domain configuration

The owner authorized switching DNS hosting to Cloudflare while keeping registration at Squarespace. The Free zone is active with nameservers `ezra.ns.cloudflare.com` and `macy.ns.cloudflare.com`. Both apex and www have proxied CNAME records to `jaffa-provisions.pages.dev`. The existing SPF (`v=spf1 -all`) and DMARC (`v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s`) TXT records were copied. No MX records were returned by the original authoritative server. DNSSEC was re-enabled and its DS record saved at Squarespace; Cloudflare reports active and a validating public resolver returns the AD flag.

For reference, the migration sequence was:

1. Add jaffaprovisions.com as a free Cloudflare zone. Before switching nameservers, compare every imported DNS record with Squarespace. Preserve MX and TXT, including SPF, DKIM, DMARC and verification; preserve other unrelated records too.
2. In Squarespace's nameserver settings, enter the exact two Cloudflare nameservers assigned to this zone. This changes DNS hosting, not domain registration. Handle any existing DNSSEC configuration using the providers' migration instructions before switching.
3. Add `jaffaprovisions.com` and `www.jaffaprovisions.com` under Pages → Custom domains and explicitly create the required proxied CNAME records via API (apex uses flattening).
4. Replace only conflicting website records at `@` and `www` with the Pages records. Identify them from the actual dashboard; don't delete records by IP guesses. Leave MX/TXT and unrelated records intact. Once nameservers point to Cloudflare, edits in Squarespace's old DNS zone no longer control the live domain.
5. Configure a Cloudflare Single Redirect to the HTTPS apex, status 301, preserving the path and query string. The expression matches www or HTTP apex requests. Ruleset ID: `0355a4dc057f4fa287eeacbe21df51a2`. No domain-wide redirect in `_redirects`: Pages does not support domain-level redirects there.
6. Wait until both domains show Active and HTTPS certificates are issued. Verify apex HTTPS, www HTTPS and the redirect with path/query preservation.

If DNS must remain at Squarespace, first add **www.jaffaprovisions.com** to Pages Custom domains, then replace the existing Squarespace `www` website CNAME with `www CNAME <actual-project>.pages.dev`. Keep MX/TXT and unrelated records. This alone does NOT serve the apex or satisfy the full spec; do not remove root records until an apex solution is agreed. Canonical URLs and the live poll currently use the apex and would need updating if www becomes canonical.

DNS and Pages were configured using the connected Cloudflare API. The owner changed nameservers and saved the DS record at Squarespace. No Terraform state is used.

## Publishing and rollback

`npm run publish` verifies main and checks for remote changes, runs the production build, stages all non-ignored changes, commits if needed, rebuilds to stamp the new SHA, pushes normally, then checks HTTPS every 15 seconds for up to five minutes. The second build resolves the order issue: the first build happens before the new commit exists. Cloudflare stamps `CF_PAGES_COMMIT_SHA`; local builds read Git HEAD. Both use seven characters in `<meta name="build-id">`.

`npm run rollback` requires a clean main equal to origin/main, creates a new commit using `git revert`, builds, pushes, and uses the same poll. It never force-pushes or resets. A conflicting revert is aborted; a failed build after a successful revert leaves the revert commit local for inspection and pushes nothing. Undo operates on the latest commit, so don't use it to remove the initial site implementation. Merge commits require manual handling.

Both scripts stop if a collaborator's remote commits have not been integrated. Resolve with a normal merge, preserving history, before retrying. A push race is safely rejected by Git. A failed push leaves the new commit local. The poll checks the exact meta tag, follows only HTTPS redirects, bypasses stale caches with a query parameter, and returns nonzero on timeout. It never treats a successful Git push as proof the site is live.

## Verification completed September 14, 2026

Production builds and responsive checks passed at 375px and 1440px. Script safety checks passed in a disposable Git repository. The real live workflow was then verified against the custom domain:

1. Verified the assigned pages.dev URL and HTTPS apex serve the site.
2. Verified HTTPS www and HTTP apex return 301 to HTTPS apex with path and query preserved. Unknown paths return 404.
3. Changed the footer temporarily, ran `npm run publish`, and confirmed Live for `ba9e7cb`; the changed wording appeared on the public site.
4. Ran `npm run rollback`, confirmed Live for `dd4825d`, and verified the original footer was restored. The content file matches its pre-test version.
5. Cloudflare reports DNSSEC active; a public validating resolver returned authenticated DNS answers. Pages custom-domain status was still pending while actual HTTPS requests already succeeded; certificate/status reporting may finish asynchronously.

## Official references checked during implementation

- https://docs.astro.build/en/install-and-setup/
- https://docs.astro.build/en/reference/configuration-reference/
- https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/
- https://developers.cloudflare.com/pages/configuration/custom-domains/
- https://developers.cloudflare.com/pages/configuration/redirects/
- https://developers.cloudflare.com/pages/how-to/www-redirect/
