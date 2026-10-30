---
name: reading-search-console
description: >
  Read Google Search Console data through Limelit: clicks, impressions, position and
  CTR, the SEO findings worth acting on, and whether a URL is indexed. Use when the user
  asks "which posts are getting traffic?", "what's our CTR?", "is this page indexed on
  Google?", or "where is the easy SEO win?".
---

# Reading Search Console

These tools need a Search Console connection on the Limelit property. If one returns empty
or not connected, tell the user to connect Search Console in the Limelit dashboard.

| The user asks | Call |
| --- | --- |
| Overall property picture | `gsc_property_summary` |
| Traffic for some or all pages | `gsc_search_analytics` (`days` up to 90, `url_list` empty for all) |
| What to work on | `gsc_findings`: content decay, cannibalisation, CTR gaps, quick wins, content gaps, traffic drops |
| Is a page indexed | `gsc_url_status` with the absolute `url` |
| The week in one view | `gsc_weekly_digest` |

A quick win or content gap whose query a tracked prompt already asks carries that prompt.
Cross-check it with `finding-lost-prompts` to see whether AI answers miss you there too.

Search Console is classic search, not AI answers. Keep the two kinds of numbers apart when
you report them.
