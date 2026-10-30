#!/usr/bin/env python3
"""PreToolUse gate for Limelit MCP tools.

Once a user allow-lists the Limelit server, every tool call runs without a
prompt, including the ones that spend credits, publish a page, or ask outside
search engines to recrawl a site. This hook puts a prompt back in front of
those calls by answering permissionDecision "ask". Read tools are left alone,
so the normal permission flow applies to them.

A tool's posture comes from hooks/tool-postures.tsv, which mirrors Limelit's
own posture table. A tool missing from the file is treated as irreversible, so
tools added to Limelit after the file was generated still reach the gate.

Three tools preview by default: reevaluate_prompt, reevaluate_all_prompts and
push_to_indexers do nothing until called with dry_run=false. A preview call
passes; only the real call is gated.

Environment:
  LIMELIT_GATE_DISABLE  set to any non-empty value to turn the gate off, for
                        example in a cloud run where no one can answer a prompt.
  LIMELIT_GATE_WRITES   set to "0" to stop asking for ordinary writes (tracking
                        a competitor, editing a draft). Spending, publishing and
                        irreversible calls still ask.
"""

import json
import os
import sys

PREVIEW_BY_DEFAULT = {"reevaluate_prompt", "reevaluate_all_prompts", "push_to_indexers"}

SPEND_ON_RUN = {"reevaluate_prompt", "reevaluate_all_prompts"}


def load_postures(path):
    """Read tool -> posture from the TSV next to this script.

    Args:
        path: Path to tool-postures.tsv.

    Returns:
        A dict of tool name to posture; empty if the file is unreadable, which
        makes every tool count as irreversible.
    """
    postures = {}
    try:
        with open(path, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                name, _, posture = line.partition("\t")
                postures[name] = posture.strip()
    except OSError:
        pass
    return postures


def reason_for(tool, posture, args):
    """Explain why a call needs a yes, or None when it can pass.

    Args:
        tool: The Limelit tool name without the mcp__ prefix.
        posture: read, metered, write or irreversible.
        args: The tool's input arguments.

    Returns:
        A short reason to show in the prompt, or None to let the call through.
    """
    if tool in PREVIEW_BY_DEFAULT and args.get("dry_run") is not False:
        return None
    if tool in SPEND_ON_RUN:
        return f"{tool} with dry_run=false starts real runs that spend credits."
    if tool == "push_to_indexers":
        return "push_to_indexers with dry_run=false asks outside search engines to recrawl your pages. A push cannot be unsent."
    if posture == "read":
        return None
    if posture == "metered":
        return f"{tool} is a paid lookup that spends credits."
    if posture == "write":
        if os.environ.get("LIMELIT_GATE_WRITES") == "0":
            return None
        return f"{tool} changes your Limelit data."
    return f"{tool} cannot be undone or reaches outside Limelit."


def main():
    if os.environ.get("LIMELIT_GATE_DISABLE"):
        return 0
    try:
        event = json.load(sys.stdin)
    except (ValueError, OSError):
        return 0
    name = event.get("tool_name") or ""
    if not name.startswith("mcp__") or "__" not in name[5:]:
        return 0
    tool = name.rsplit("__", 1)[1]
    args = event.get("tool_input") or {}
    if not isinstance(args, dict):
        args = {}
    here = os.path.dirname(os.path.abspath(__file__))
    posture = load_postures(os.path.join(here, "tool-postures.tsv")).get(tool, "irreversible")
    reason = reason_for(tool, posture, args)
    if reason is None:
        return 0
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "ask",
                "permissionDecisionReason": "Limelit: " + reason,
            }
        },
        sys.stdout,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
