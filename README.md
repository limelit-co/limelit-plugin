# Limelit plugin

See how ChatGPT, Claude, Perplexity, Gemini, Google AI Overviews and Google AI Mode
mention and cite your brand against your competitors, find the prompts you lose and the
sources to earn, and draft what to publish next, without leaving your AI coding tool.

The plugin connects Claude Code to the [Limelit](https://limelit.co) MCP server and adds
skills, slash commands, an analyst subagent, and a safety hook for anything that spends
credits or cannot be undone.

## Install

```
/plugin marketplace add limelit-co/limelit-plugin
/plugin install limelit@limelit
```

Then sign in: run `/mcp`, choose the Limelit server, and select **Authenticate**. Your browser
opens limelit.co, you sign in and allow access, and Claude Code stores the grant. The grant
shows up in Limelit under **Settings, API keys** as "Claude Code (signed in)", where you can
revoke it at any time. It lasts 90 days and carries your current role.

You need a Limelit account with a brand set up. Start at [limelit.co](https://limelit.co).

## What you can ask

- "How visible are we in AI search this month, and who is ahead?"
- "Which prompts does ChatGPT leave us out of, and why?"
- "What gets cited instead of us?"
- "What should we write next?"
- "Re-run our prompts" (you see the plan and the credit cost before anything runs)

## Slash commands

| Command | What it does |
| --- | --- |
| `/limelit:visibility [days]` | Headline visibility, share of voice, competitors and top sources |
| `/limelit:lost-prompts [engine or topic]` | Prompts where answers leave you out, and why |
| `/limelit:easy-wins` | Sources cited for competitors but not for you, ranked |
| `/limelit:next-post [topic]` | The next post to write, with the evidence |

## Skills

| Skill | Covers |
| --- | --- |
| `checking-ai-visibility` | Visibility, share of voice, trends, which engine is weak |
| `finding-lost-prompts` | The prompt by engine grid and the missed answers behind it |
| `finding-sources-to-earn` | Source gaps, easy wins, the Plan queue |
| `planning-what-to-write` | Picking the next post or refresh, briefs |
| `drafting-and-publishing` | Drafts, quality scoring, publishing |
| `running-prompts` | Preview, confirm and run prompts; spend and caps |
| `pushing-to-indexers` | Indexing status, IndexNow and Google sitemap pushes |
| `reading-search-console` | Search Console traffic, findings and URL status |

The `visibility-analyst` subagent runs a full read-only review and returns one short summary.

## The safety hook

Allow-listing the Limelit server would otherwise let every call run without a prompt. The
plugin's `PreToolUse` hook asks you first before:

- a run with `dry_run=false` (it spends credits),
- a push to the search indexes with `dry_run=false` (it cannot be unsent),
- publishing, deleting, or any other call that cannot be undone,
- paid lookups (SERP, AI Overview, AI Mode, keyword and volume lookups),
- ordinary writes such as tracking a competitor or editing a draft.

Previews (`dry_run` left out or `true`) and read-only tools pass straight through. Each tool's
posture comes from `hooks/tool-postures.tsv`, which mirrors Limelit's own classification. A tool
missing from that file is treated as irreversible, so new tools are gated until the file
catches up.

Settings:

- `LIMELIT_GATE_WRITES=0` stops asking for ordinary writes. Spending, publishing and
  irreversible calls still ask.
- `LIMELIT_GATE_DISABLE=1` turns the hook off, for example in an unattended cloud run.

The hook needs `python3` on your PATH.

## Prefer an API key?

Create a key in Limelit under **Settings, API keys** and add the server yourself:

```
claude mcp add --transport http limelit https://api.limelit.co/mcp \
  --header "Authorization: Bearer lmlt_..."
```

## Development

```
claude --plugin-dir .
bash tests/test_gate.sh
```

## License

MIT
