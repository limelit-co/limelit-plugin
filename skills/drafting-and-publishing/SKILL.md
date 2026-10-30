---
name: drafting-and-publishing
description: >
  Write, score, revise and publish a Limelit blog post or landing page draft built to be
  cited by AI answers. Use when the user asks to "write a post about X", "draft a
  counter-post", "improve this draft", "score this article", or "publish the draft".
---

# Drafting and publishing

## Write

`generate_draft` with `source_url` (the article to write against). Useful options:

- `brief_id`: write from a reviewed brief (`create_brief`, `list_briefs`).
- `target_query`: the buyer query the post must capture, used in the H1, meta and first paragraph.
- `style`: `how_to`, `opinion`, `data_breakdown`, `q_and_a` or `story`. Vary it across drafts.
- `page_type` with `page_subject`: a `use_case`, `comparison` or `alternatives` landing page.
- `brand_strength`: `light`, `balanced` (default) or `strong`.

Drafting calls a model and can take minutes. It spends credits, so the plugin asks first.

## Score and revise

- `score_content_quality` with `draft_id` scores 0 to 100 on seven checks and returns a
  rewrite instruction for each failing one. It calls no model and costs nothing, so run it
  after every revision.
- `get_draft_structure` and `get_draft_keyword_coverage` show what the draft covers.
- `update_draft` saves changes.
- Add quotations and statistics only from sources you can link. Never invent one.

## Publish

`publish_draft` with `id` makes the post public at a permanent URL, lists it in the sitemap
and exposes it to AI crawlers. It cannot be undone, so the plugin always asks first. Before
calling it:

1. Show the user the title, the URL slug it will get, and the latest quality score.
2. Get an explicit yes.

After publishing, offer the `pushing-to-indexers` skill so search indexes pick the page up.
For a site that publishes through its own CMS, use `list_cms_destinations` and
`create_cms_draft` instead.
