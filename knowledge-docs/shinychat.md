---
title: "Chat UI Component for shiny"
source: "https://posit-dev.github.io/shinychat/r/index.html"
language: "en"
description: "Provides a scrolling chat interface with multiline input, suitable for creating chatbot apps based on Large Language Models (LLMs). Designed to work particularly well with the ellmer R package for calling LLMs."
word_count: 154
---

**shinychat** provides a [Shiny](https://shiny.posit.co/) toolkit for building generative AI applications like chatbots and [streaming content](https://posit-dev.github.io/shinychat/r/reference/markdown_stream.html). It’s designed to work alongside the [ellmer](https://ellmer.tidyverse.org/) package, which handles response generation.

## Installation

You can install shinychat from CRAN with:

```
install.packages("shinychat")
```

Or, install the development version of shinychat from [GitHub](https://github.com/) with:

```
# install.packages("pak")
pak::pak("posit-dev/shinychat/pkg-r")
```

## Example

To run this example, you’ll first need to create an OpenAI API key, and set it in your environment as `OPENAI_API_KEY`.

You’ll also need to install the [ellmer](https://ellmer.tidyverse.org/) package (with `install.packages("ellmer")`).

```
library(shiny)
library()

ui <- bslib::page_fillable(
  chat_ui(
    id = "chat",
    messages = "**Hello!** How can I help you today?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <-
    ellmer::chat_openai(
      system_prompt = "Respond to the user as succinctly as possible."
    )

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

![Screenshot of the resulting app.](https://posit-dev.github.io/shinychat/r/reference/figures/app.png)

## Next steps

Ready to start building a chatbot with shinychat? See [Get Started](https://posit-dev.github.io/shinychat/r/articles/get-started.html) to learn more.