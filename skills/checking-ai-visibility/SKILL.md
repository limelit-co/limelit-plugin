---
name: checking-ai-visibility
description: >
  Report how visible a brand is in AI answers (ChatGPT, Claude, Perplexity, Gemini,
  Google AI Overviews, Google AI Mode) using Limelit: visibility, share of voice,
  citation share, average position, who is ahead, and how it moved over time.
  Use when the user asks "how are we doing in AI search?", "who is ahead of us in
  ChatGPT?", "what is our share of voice?", or wants a visibility trend or summary.
---

# Checking AI visibility

## First move, every time

1. Call `get_active_property`. It names the brand, the engines tracked, and a setup block.
2. If `has_answers` is false, nothing has run yet. Tell the user the `next_step` it returns,
   with its dashboard link, and report no numbers.
3. Otherwise call `analyze_my_visibility` (trailing 30 days by default, `days` 1 to 90).
   It returns brand visibility, citation share, the top competitors by mentions and the
   top cited sources in one call.

## Going deeper

| The user asks | Call |
| --- | --- |
| Numbers for a set window | `get_overview_kpis` with `days` |
| How it moved over time | `show_visibility_trend`, or `get_kpi_history` |
| Share of voice against competitors | `show_share_of_voice` |
| Which engine is the weak one | `get_matrix` (one cell per prompt and engine) |
| Are the numbers current | `get_run_activity` |

## Reporting rules

- Quote the n behind every figure: the number of answers it rests on.
- A figure resting on fewer than 20 answers is still settling. Say so.
- Never report a metric a tool did not return. Do not compute your own visibility from raw chats.
- Headline visibility leaves out prompts tagged as branded (prompts that name the brand).
  `get_matrix` includes them and flags them.
- Name the engines a figure covers. Some engines are read through their API and some
  through scraped answers, and a window can mix both.

## Next steps to offer

- Which prompts we lose: the `finding-lost-prompts` skill.
- What gets cited instead of us: the `finding-sources-to-earn` skill.
- What to write next: the `planning-what-to-write` skill.
