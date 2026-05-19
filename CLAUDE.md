# R/Pharma GenAI Day 2026 Chat App

A shinychat-based interactive app built for the 2026 R/Pharma GenAI Day, implemented in R.

## Configuration

`MAX_USER_TURNS` in `app.R` controls the per-session message limit. It is interpolated into both `welcome-message.md` and the turn-check logic, so it only needs to be changed in one place. Update the README and welcome message copy if the number is referenced explicitly anywhere else.

## Context Docs

Reference docs in `context-docs/` are injected into the LLM system prompt at app startup. All `.md` files in the folder (except `links.md`) are concatenated and passed as the `context_docs` variable to `system-prompt.md`.

To add or refresh a source, fetch it with defuddle:

```
/defuddle https://example.com/some-page
```

Save the output to `context-docs/<name>.md` and add the URL to `context-docs/links.md`. Restart the app to pick up changes.

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
