# R/Pharma GenAI Day 2026 chat app

This repository contains a shinychat-based application built for the 2026 R/Pharma GenAI Day. The project is implemented in R and consists of several scripts and an interactive app.

## Tech Stack

| Package | Role |
|---------|------|
| [shinychat](https://posit-dev.github.io/shinychat/r/) | Chat UI component for Shiny |
| [ellmer](https://ellmer.tidyverse.org) | LLM provider interface (Anthropic, OpenAI, etc.) |
| [ragnar](https://ragnar.tidyverse.org) | RAG / knowledge retrieval (to be wired up) |
| [bslib](https://rstudio.github.io/bslib/) | Shiny layout and theming |

The app uses `chat_anthropic()` with `claude-sonnet-4-6` by default. Swap the `chat_*()` function in `app.R` to change provider.

## Configuration

| Constant | File | Default | Description |
|----------|------|---------|-------------|
| `MAX_USER_TURNS` | `app.R` | `10` | Maximum number of user messages per session. When reached, the user is prompted to refresh. Keeps API costs bounded. |

## Setup

You'll need an Anthropic API key to run the app. The quickest way to add it:

```r
usethis::edit_r_environ()
```

Add this line, save, and restart R:

```
ANTHROPIC_API_KEY=your-key-here
```

Get a key at [console.anthropic.com](https://console.anthropic.com).

## Knowledge Sources

> Note: fetched content is stored in `knowledge-docs/` (gitignored except for [`knowledge-docs/links.md`](knowledge-docs/links.md)). Sources were fetched as clean raw markdown via [defuddle.md](https://defuddle.md) — no AI summarisation.

`knowledge-docs/links.md` is a tracked index of every URL fetched, organised by category. Update it whenever a new source is added.

To repopulate `knowledge-docs/` yourself, you can use `curl` directly:

```bash
curl -s "https://defuddle.md/posit-dev.github.io/shinychat/r/index.html" > knowledge-docs/shinychat.md
```

Or if you're using Claude Code with the `/defuddle` skill installed (see `.claude/skills/defuddle/`), you can run:

```
/defuddle https://posit-dev.github.io/shinychat/r/index.html
```

The skill handles filename inference and saves to `knowledge-docs/` automatically. Note: defuddle does not work with PDFs — fetch those separately.


