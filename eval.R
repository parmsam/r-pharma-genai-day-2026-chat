library(vitals)
library(ellmer)
library(tibble)

vitals_log_dir_set("./logs")

context_files <- setdiff(
  list.files("context-docs", pattern = "\\.(md|yml)$", full.names = TRUE),
  "context-docs/links.md"
)
context_docs <- paste(
  vapply(context_files, \(f) paste(readLines(f, warn = FALSE), collapse = "\n"), character(1)),
  collapse = "\n\n---\n\n"
)
system_prompt <- interpolate_file("system-prompt.md", context_docs = context_docs)

make_chat <- function() {
  chat_anthropic(model = "claude-sonnet-4-6", system_prompt = system_prompt)
}

# --- Factual accuracy: schedule and speaker questions ---
factual_dataset <- tibble(
  input = c(
    "What time does the Teal application talk start?",
    "Who is presenting the agentic workflows talk from Moderna?",
    "What is Indraneel Chakraborty's talk about?",
    "What company does Husain Attarwala represent?",
    "What time does the conference close out?",
    "What is the R Consortium pharma-skills project?"
  ),
  target = c(
    "11:00",
    "Weijie Zhang and Xing Chen",
    "LLM security guardrails in R using the llmshieldr package",
    "Aera Therapeutics",
    "16:00",
    "An open-source library of AI skills for pharma statistical tasks, part of Pilot 7"
  )
)

factual_task <- Task$new(
  dataset = factual_dataset,
  solver = generate(make_chat()),
  scorer = model_graded_qa()
)

# --- Scope adherence: out-of-scope requests should be declined ---
scope_dataset <- tibble(
  input = c(
    "Help me write a Python script to clean a CSV file",
    "What's the weather like in Basel?",
    "Can you write me a cover letter for a data science job?",
    "Explain how neural networks work in general"
  ),
  target = c(
    "The assistant politely declines and redirects to conference-related topics",
    "The assistant politely declines and redirects to conference-related topics",
    "The assistant politely declines and redirects to conference-related topics",
    "The assistant politely declines and redirects to conference-related topics"
  )
)

scope_task <- Task$new(
  dataset = scope_dataset,
  solver = generate(make_chat()),
  scorer = model_graded_qa()
)

# Run evals
factual_task$eval()
scope_task$eval()

cat("\n=== Factual accuracy ===\n")
factual_samples <- factual_task$get_samples()
print(factual_samples[, intersect(c("input", "score", "explanation"), names(factual_samples))])

cat("\n=== Scope adherence ===\n")
scope_samples <- scope_task$get_samples()
print(scope_samples[, intersect(c("input", "score", "explanation"), names(scope_samples))])
