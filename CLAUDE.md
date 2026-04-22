# R/Pharma GenAI Day 2026 Chat App

A shinychat-based interactive app built for the 2026 R/Pharma GenAI Day, implemented in R.

## Configuration

`MAX_USER_TURNS` in `app.R` controls the per-session message limit. It is interpolated into both `welcome-message.md` and the turn-check logic, so it only needs to be changed in one place. Update the README and welcome message copy if the number is referenced explicitly anywhere else.

## Knowledge Docs

Reference documentation lives in `knowledge-docs/` (gitignored). To add a new source, use the `/defuddle` skill:

```
/defuddle https://example.com/some-page
```

Or via curl:

```bash
curl -s "https://defuddle.md/<url-without-scheme>" > knowledge-docs/<name>.md
```

`knowledge-docs/links.md` is the tracked index of all fetched URLs — update it whenever a new source is added.
