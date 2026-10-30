---
name: pushing-to-indexers
description: >
  Get published pages into the search indexes AI engines read: check indexing status,
  then push pages to IndexNow (Bing, Yandex and others) and resubmit the sitemap to
  Google. Use when the user asks "is my post indexed?", "push this page to Bing",
  "why isn't ChatGPT search finding my page?", or "submit to IndexNow".
---

# Pushing pages to the indexes

## Check first

`get_indexing_status` returns the IndexNow setup, each host's key file state, the Google
sitemap state, every pushable page with its last push, and each page's Google standing
(`indexed`, `not_indexed`, `unknown_to_google`, `not_checked`).

- A page with `eligible=false` says why in `reason`.
- A host whose key file is not served is skipped, never guessed.
- Google only takes per-page indexing requests by hand: give the user the page's
  `google_deep_link` and they click Request indexing in Search Console.
- Brave takes manual submissions only; the status includes its form URL.

## Push

Only push when the user asks for a push. It spends no credits, but it asks outside engines
to recrawl the site, and a push cannot be unsent.

1. Call `push_to_indexers` with no `dry_run` (preview is the default). Choose pages with
   `urls` (exact URLs from the status) or `scope` (`posts`, `owned`, `all`). It returns the
   exact batches it would send.
2. Show the user the batches and get a clear yes.
3. Call again with `dry_run=false`. The plugin asks for permission on this call.

Owner only.
