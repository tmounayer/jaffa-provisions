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

Use the URL printed by Astro. Production output goes to `dist`. The lockfile pins the tested dependencies. Astro 7.3.2 was the latest stable version installed from the registry during setup. No GitHub Actions.

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

In Cloudflare's free account, create a **Pages** project and connect this existing GitHub repository. Authorize access to this repository. Use:

| Setting | Value |
| --- | --- |
| Framework preset | Astro |
| Production branch | main |
| Build command | npm run build |
| Build output directory | dist |
| Root directory | repository root (leave blank) |
| Node | 24 via .node-version |

Do not add a server adapter, Worker, credit card, analytics, or paid features. Save and Deploy, then send Codex the exact assigned `pages.dev` URL. The name may already be taken, so do not assume the URL from the repo name. Cloudflare rebuilds on pushes to main. Account connection, first deployment and live verification are pending.

## Domain: a constraint that needs a decision

Keep the domain REGISTERED at Squarespace. Cloudflare Pages requires Cloudflare authoritative nameservers for the apex `jaffaprovisions.com`; root A records at Squarespace are not a supported substitute. Thus the original requirement to change only DNS records at Squarespace cannot serve the apex directly with Pages.

For both apex and www on Pages, use Cloudflare Free DNS while keeping Squarespace as registrar:

1. Add jaffaprovisions.com as a free Cloudflare zone. Before switching nameservers, compare every imported DNS record with Squarespace. Preserve MX and TXT, including SPF, DKIM, DMARC and verification; preserve other unrelated records too.
2. In Squarespace's nameserver settings, enter the exact two Cloudflare nameservers assigned to this zone. This changes DNS hosting, not domain registration. Handle any existing DNSSEC configuration using the providers' migration instructions before switching.
3. After the zone is active, add `jaffaprovisions.com` and `www.jaffaprovisions.com` under Pages → Custom domains. Cloudflare creates the required CNAME records to the project's actual `pages.dev` hostname (apex uses flattening).
4. Replace only conflicting website records at `@` and `www` with the Pages records. Identify them from the actual dashboard; don't delete records by IP guesses. Leave MX/TXT and unrelated records intact. Once nameservers point to Cloudflare, edits in Squarespace's old DNS zone no longer control the live domain.
5. Configure a Cloudflare Bulk Redirect from `https://www.jaffaprovisions.com/` to `https://jaffaprovisions.com/`, status 301, preserving path suffix and query string and enabling subpath matching. Follow the official www-to-apex guide. No domain-wide redirect in `_redirects`: Pages does not support domain-level redirects there.
6. Wait until both domains show Active and HTTPS certificates are issued. Verify apex HTTPS, www HTTPS and the redirect with path/query preservation.

If DNS must remain at Squarespace, first add **www.jaffaprovisions.com** to Pages Custom domains, then replace the existing Squarespace `www` website CNAME with `www CNAME <actual-project>.pages.dev`. Keep MX/TXT and unrelated records. This alone does NOT serve the apex or satisfy the full spec; do not remove root records until an apex solution is agreed. Canonical URLs and the live poll currently use the apex and would need updating if www becomes canonical.

No DNS or account changes have been made by Codex.

## Publishing and rollback

`npm run publish` verifies main and checks for remote changes, runs the production build, stages all non-ignored changes, commits if needed, rebuilds to stamp the new SHA, pushes normally, then checks HTTPS every 15 seconds for up to five minutes. The second build resolves the order issue: the first build happens before the new commit exists. Cloudflare stamps `CF_PAGES_COMMIT_SHA`; local builds read Git HEAD. Both use seven characters in `<meta name="build-id">`.

`npm run rollback` requires a clean main equal to origin/main, creates a new commit using `git revert`, builds, pushes, and uses the same poll. It never force-pushes or resets. A conflicting revert is aborted; a failed build after a successful revert leaves the revert commit local for inspection and pushes nothing. Undo operates on the latest commit, so don't use it to remove the initial site implementation. Merge commits require manual handling.

Both scripts stop if a collaborator's remote commits have not been integrated. Resolve with a normal merge, preserving history, before retrying. A push race is safely rejected by Git. A failed push leaves the new commit local. The poll checks the exact meta tag, follows only HTTPS redirects, bypasses stale caches with a query parameter, and returns nonzero on timeout. It never treats a successful Git push as proof the site is live.

## Verification and remaining launch test

Production build and responsive/local checks are performed during setup. Script behavior is checked separately in a disposable local Git repository; that is not proof of a Cloudflare deployment.

After Cloudflare and DNS are ready, Codex must still:

1. Verify the assigned pages.dev URL serves this build.
2. Verify HTTPS on apex and www, with a single canonical redirect.
3. Make a trivial content change, run `npm run publish`, and confirm the poll reports Live and the changed copy is visible.
4. Run `npm run rollback`, confirm Live again, and verify the changed copy is gone.

## Official references checked during implementation

- https://docs.astro.build/en/install-and-setup/
- https://docs.astro.build/en/reference/configuration-reference/
- https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/
- https://developers.cloudflare.com/pages/configuration/custom-domains/
- https://developers.cloudflare.com/pages/configuration/redirects/
- https://developers.cloudflare.com/pages/how-to/www-redirect/
