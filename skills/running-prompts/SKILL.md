---
name: running-prompts
description: >
  Run tracked prompts again to get fresh AI answers, safely: preview first, confirm the
  credit cost, then run and watch it finish. Also covers spend and spending caps. Use
  when the user asks to "re-run the prompts", "refresh the numbers", "check this prompt
  again", "how much have we spent?", or "why did the runs stop?".
---

# Running prompts

Runs spend credits. Never start one unless the user asked for a run.

## Preview, confirm, run

1. Call `reevaluate_all_prompts` (or `reevaluate_prompt` with a `prompt_id` from `list_prompts`)
   with no `dry_run`, or `dry_run=true`. That is a preview: it returns the answers planned and
   the estimated credits, and runs nothing.
2. Show the user the plan and the cost. Wait for a clear yes.
3. Call again with `dry_run=false`. The plugin asks for permission on this call even if the
   Limelit server is allow-listed.
4. Poll `get_run_activity` until its status is `done`, `failed` or `cancelled`. Report answers
   completed and failed.

Fresh answers take time to show up in the headline numbers. Re-read with
`analyze_my_visibility` after the run is done, not during it.

## Spend

- `get_spend_summary`: today's and month-to-date cost, the daily and monthly budgets, and a
  day-by-day series. Use it when runs stopped: a budget cap is the usual reason.
- `set_spending_caps` changes the caps. Owner only, and it changes billing behavior, so confirm
  the new values with the user first.

## Adding prompts

`create_prompt` adds a tracked prompt and starts spending on its runs. Confirm the wording and
that the user wants it tracked before calling it.
