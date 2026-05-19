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

## Context Docs

**What it is:** Small, curated, event-specific content that is injected directly into the LLM system prompt on every request. The model always has this information in view — no retrieval step.

**When to add something here:** It's directly about this event (schedule, speakers, abstracts, FAQs). Keep it small; everything in this folder costs tokens on every turn.

`context-docs/` is checked into git. All `.md` and `.yml` files (except `links.md`) are concatenated and passed as the `context_docs` variable to `system-prompt.md` at app startup.

| File | Contents |
|------|----------|
| `ai-day.md` | R/Pharma genAI Day 2026 event overview and details |
| `zoom-event.md` | Session schedule with speakers (clipped from Zoom event page) |
| `schedule.yml` | Full schedule with talk abstracts, speaker bios, and affiliations |
| `links.md` | Index of source URLs and fetch dates |

To refresh a source, re-fetch it and overwrite the file, then restart the app:

```bash
curl -s "https://defuddle.md/rinpharma.com/docs/ai-day/" > context-docs/ai-day.md
# or for GitHub-hosted files:
curl -s "https://raw.githubusercontent.com/rinpharma/rinpharma/main/docs/ai-day/schedule.yml" > context-docs/schedule.yml
```

## Knowledge Docs

**What it is:** Larger reference documentation (R package docs, guides, etc.) intended for RAG retrieval via `ragnar`. These are *not* injected into the system prompt — they are fetched on demand based on the user's query.

**When to add something here:** It's background reference material (package docs, tutorials, papers) that the model may need to look up rather than always knowing.

`knowledge-docs/` is gitignored except for [`knowledge-docs/links.md`](knowledge-docs/links.md), which is the tracked index of every URL fetched. Sources are fetched as clean raw markdown via [defuddle.md](https://defuddle.md) — no AI summarisation.

To repopulate `knowledge-docs/` yourself:

```bash
curl -s "https://defuddle.md/posit-dev.github.io/shinychat/r/index.html" > knowledge-docs/shinychat.md
```

Or with the `/defuddle` skill in Claude Code:

```
/defuddle https://posit-dev.github.io/shinychat/r/index.html
```

Note: defuddle does not work with PDFs — fetch those separately.


