# Jaffa Provisions

This is a small, fully static Astro marketing website for a new food business. The owner is nontechnical and works through plain-English requests to Codex; explain results briefly, handle Git for them, and keep the implementation simple. There is one content file, one homepage, and one shared layout. Cloudflare Pages builds from GitHub main. Use free tiers only, with no server adapter, CMS, database, auth, analytics, third-party scripts, or CSS framework. The domain remains registered at Squarespace.

## Phrase mappings

- “publish”, “push it to production”, “make it live”, “deploy”: run `npm run publish` and report the actual result. Do not report Live unless its verification succeeds.
- “preview”, “show me”, “let me see it”: run `npm run dev` and tell the user to open the local URL printed by Astro; open it in the app when available.
- “undo”, “roll back”, “put it back”: run `npm run rollback`. This reverses the most recent commit on main. If it stops because unpublished work exists or histories differ, preserve the work and explain the blocker.

## Rules

- Never force push. Never rewrite history or use reset. Integrate collaborator changes with a normal merge when needed.
- Never edit files outside `src/content/site.ts` and `public/images` unless the user asks for a layout or design change. An explicit user request for infrastructure, script fixes or documentation authorizes that requested work.
- Always run the production build before publishing; the publish script handles it.
- After any content change, offer to preview before publishing. If the user already explicitly requested publishing, that is authorization to continue.
- All editable text, links, image paths, alt text, labels, metadata, and theme choices live in `src/content/site.ts`. Images go in `public/images`.
- Do not add dependencies unless needed and explain why. Do not add GitHub Actions; Cloudflare builds on push.
- The repository is public per the owner's explicit choice before the website spec. Do not change visibility or collaborator access without a new request.
- Use `HOW_TO_CHANGE_THE_SITE.md` for owner guidance and `DEVELOPER_NOTES.md` for setup details and remaining launch verification.

## Local runtime

Use Node 24. If npm is not on this Mac's PATH, prepend `/opt/homebrew/opt/node@24/bin:/opt/homebrew/bin` for commands. Keep `npm run dev` and `npm run preview` available. Do not use the Sites/Vinext starter or Sites hosting: the user explicitly requires Astro static output and Cloudflare Pages.

## First launch status

Cloudflare Pages is connected to GitHub main. Production is https://jaffaprovisions.com and the Pages URL is https://jaffa-provisions.pages.dev. Squarespace remains the registrar; Cloudflare hosts DNS on its Free plan. DNSSEC is active. A Cloudflare Single Redirect sends www and HTTP to the HTTPS apex, preserving paths and queries. Use `npm run publish` for subsequent publication requests. See DEVELOPER_NOTES.md for live verification evidence.
