---
name: finding-sources-to-earn
description: >
  Find the sites and pages AI answers cite instead of the brand, and rank them by how
  much a mention there would help. Use when the user asks "what gets cited instead of
  us?", "which sources should we get on?", "which page of a competitor is winning?",
  or "where should we do outreach?".
---

# Finding sources to earn

Start with `get_active_property`. If `has_answers` is false, give its `next_step` and stop.

## The worklist

1. `list_top_sources`: the most cited sites in your category.
2. `list_source_gaps`: the same sources ranked by gap, meaning how often a source was
   retrieved or cited versus how often your brand appeared alongside it. Pick the grain
   with `dimension` (`domains`, `hosts`, `urls`) and filter with `source_type`
   (`owned`, `competitor`, `informational`, `other`).
3. `list_source_urls` with `value` set to a bare host (for example `example.com`, not a URL)
   shows exactly which pages on that site get cited.
4. `compare_source_to_brand` with `value` set to a tracked competitor's domain puts its
   source presence next to yours over the same prompts.

## Ready-made shortlists

- `find_easy_wins`: pages where at least one tracked competitor is cited and you are not.
  These already have proven reach in AI answers.
- `list_opportunities`: the ranked Plan queue (win, defend, winning), each with a score,
  a proposed action and the citation evidence.

## Choosing the action

- A competitor's own page cannot take an inclusion pitch. Write a stronger page instead
  (see `planning-what-to-write`).
- A publisher, directory or review page can. Limelit drafts the pitch; the user sends it
  from their own mailbox. Limelit never sends outreach itself.
- An owned page that is cited less than before is a refresh candidate: `list_citation_drops`.

## Rules

- Quote n with every count.
- Never report a metric a tool did not return.
