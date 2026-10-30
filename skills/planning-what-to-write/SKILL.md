---
name: planning-what-to-write
description: >
  Decide the next page or post to publish so AI answers cite the brand: pick the
  highest-leverage topic, the buyer query it must capture, and a brief. Use when the
  user asks "what should we write next?", "what should we work on?", "give me a
  content plan for AI search", or "which post should we refresh?".
---

# Planning what to write

Start with `get_active_property`. If `has_answers` is false, give its `next_step` and stop.

## Pick the target

| Situation | Call |
| --- | --- |
| One best next post, with a reason | `suggest_my_next_blog_post` |
| The full ranked action list | `list_opportunities` (filter `bucket`: `win`, `defend`, `winning`) |
| Pages competitors win and you do not | `find_easy_wins` |
| Your posts AI engines cite less than before | `list_citation_drops` |
| Search Console demand you are missing | `gsc_findings` (see `reading-search-console`) |

## Shape the piece

- The searches engines ran behind lost answers (from `get_chat`) are the questions the
  page must answer. `get_fanouts` and `get_fanout_phrases` collect them.
- `create_brief` turns a source URL into a reviewable angle, outline and question list.
  Review it with the user before drafting.
- A competitor's page wins? Consider a comparison or alternatives landing page instead of
  a blog post (`generate_draft` with `page_type`).

## Then

Hand off to the `drafting-and-publishing` skill to write, score and publish.

## Rules

- Recommend one thing first, with the evidence and its n, then the runners-up.
- Do not invent statistics or quotations for a plan. Every claim needs a source you can link.
