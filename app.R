library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

MAX_USER_TURNS <- 10

agenda <- readLines("agenda.md", warn = FALSE) |> paste(collapse = "\n")
system_prompt <- interpolate_file("system-prompt.md", agenda = agenda)
welcome_message <- interpolate_file("welcome-message.md", max_turns = MAX_USER_TURNS)

ui <- page_fillable(
  fillable_mobile = TRUE,
  title = "R/Pharma GenAI Day 2026",
  chat_ui(
    id = "chat",
    messages = welcome_message
  )
)

server <- function(input, output, session) {
  chat <- chat_anthropic(
    model = "claude-sonnet-4-6",
    system_prompt = system_prompt
  )

  observeEvent(input$chat_user_input, {
    # Each exchange = 1 system turn + pairs of user/assistant turns.
    # User turns are the odd-indexed turns after the system turn.
    user_turns <- sum(sapply(chat$turns, \(t) t$role == "user"))

    if (user_turns >= MAX_USER_TURNS) {
      chat_append("chat", "I'm sorry, this conversation has reached its limit. Please refresh the page to start a new one.")
      return()
    }

    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
