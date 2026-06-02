# R/Pharma GenAI Day 2026 Chat App

A shinychat-based interactive app built for the 2026 R/Pharma GenAI Day, implemented in R.

## Configuration

`MAX_USER_TURNS` in `app.R` controls the per-session message limit. It is interpolated into both `welcome-message.md` and the turn-check logic, so it only needs to be changed in one place. Update the README and welcome message copy if the number is referenced explicitly anywhere else.

## App Context

**Always in the system prompt.** Small, event-specific content (schedule, speakers, abstracts). Everything here costs tokens on every turn — keep it focused.

All `.md` and `.yml` files in `app-context/` (except `links.md`) are concatenated and passed as `context_docs` to `system-prompt.md` at startup. Restart the app to pick up changes.

To add or refresh a source:

```
/defuddle https://example.com/some-page
```

Save to `app-context/<name>.md` and update `app-context/links.md`.

## Dev Context

**Development reference only.** Larger reference material (package docs, guides) fetched for context during development. Not currently wired into the app at runtime. Lives in `dev-context/` (gitignored except `links.md`).

To add a new source:

```
/defuddle https://example.com/some-page
```

Or via curl:

```bash
curl -s "https://defuddle.md/<url-without-scheme>" > dev-context/<name>.md
```

Update `dev-context/links.md` whenever a new source is added.
