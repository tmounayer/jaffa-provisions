# Changing your Jaffa Provisions website

You do not need to open code or run commands. Open this project in Codex and describe what you want.

Try requests like:

- “Change the headline to ‘Something good is coming.’”
- “Swap the hero image for the file I put in public/images.”
- “Add a section called Catering with this text: …”
- “Add my email address to the footer: …”
- “Use a darker green and a softer orange.”

All current copy and imagery are starting placeholders. There is no invented contact address, phone number, or active mailing list. Tell Codex your details when ready. Email signup is off until you supply a hosted form link; it loads no embedded third-party script.

## Three phrases

**Preview** — opens a local preview so you can review changes. It does not publish them. The preview works while the local server is running on your Mac.

**Publish** — checks the website, saves the changes to GitHub, and waits for Cloudflare to put them live. Publishing usually takes about a minute, but can take longer. Codex checks for up to five minutes and reports “Live” only when it sees the correct version at https://jaffaprovisions.com.

**Undo** — reverses the most recent committed update and publishes that reversal. It preserves history. It is not an undo of every edit in the conversation. If unpublished edits exist, Codex will preserve them first. Saying undo again reverses the reversal.

After Codex reports “Live,” open https://jaffaprovisions.com and check the change. If publishing times out, ask Codex to check the deployment. A timeout does not necessarily mean deployment failed; Cloudflare might still be building.

## Your live website

The site is live at https://jaffaprovisions.com. The www address redirects there automatically. Cloudflare builds updates from GitHub. The domain stays registered at Squarespace; Cloudflare now manages DNS, with DNSSEC protection enabled. No further domain setup is needed for normal site edits.

The hosting stack uses free tiers; existing domain registration renewals remain separate. Do not enable paid add-ons or Cloudflare Web Analytics.
