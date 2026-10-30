#!/usr/bin/env bash
# Exercises hooks/gate-spend.py with the inputs Claude Code sends it.
# Run from the repo root: bash tests/test_gate.sh
set -u
GATE="$(cd "$(dirname "$0")/.." && pwd)/hooks/gate-spend.py"
fail=0

check() {
  local want="$1" input="$2" env="${3:-}"
  local out
  out=$(env $env python3 "$GATE" <<<"$input")
  local got=pass
  [[ "$out" == *'"permissionDecision": "ask"'* ]] && got=ask
  if [[ "$got" != "$want" ]]; then
    echo "FAIL want=$want got=$got env=[$env] input=$input"
    fail=1
  fi
}

P=mcp__plugin_limelit_limelit__
check pass "{\"tool_name\":\"${P}get_matrix\",\"tool_input\":{}}"
check pass "{\"tool_name\":\"mcp__limelit__list_chats\",\"tool_input\":{\"show\":\"missed\"}}"
check pass "{\"tool_name\":\"${P}reevaluate_all_prompts\",\"tool_input\":{}}"
check pass "{\"tool_name\":\"${P}reevaluate_all_prompts\",\"tool_input\":{\"dry_run\":true}}"
check ask  "{\"tool_name\":\"${P}reevaluate_all_prompts\",\"tool_input\":{\"dry_run\":false}}"
check ask  "{\"tool_name\":\"${P}reevaluate_prompt\",\"tool_input\":{\"prompt_id\":3,\"dry_run\":false}}"
check pass "{\"tool_name\":\"${P}push_to_indexers\",\"tool_input\":{\"scope\":\"posts\"}}"
check ask  "{\"tool_name\":\"${P}push_to_indexers\",\"tool_input\":{\"dry_run\":false}}"
check ask  "{\"tool_name\":\"${P}publish_draft\",\"tool_input\":{}}"
check ask  "{\"tool_name\":\"${P}search_serp\",\"tool_input\":{}}"
check ask  "{\"tool_name\":\"${P}track_competitor\",\"tool_input\":{}}"
check pass "{\"tool_name\":\"${P}track_competitor\",\"tool_input\":{}}" "LIMELIT_GATE_WRITES=0"
check ask  "{\"tool_name\":\"${P}publish_draft\",\"tool_input\":{}}" "LIMELIT_GATE_WRITES=0"
check ask  "{\"tool_name\":\"${P}a_tool_added_later\",\"tool_input\":{}}"
check pass "{\"tool_name\":\"${P}publish_draft\",\"tool_input\":{}}" "LIMELIT_GATE_DISABLE=1"
check pass "not json"

# The matcher in hooks.json must catch Limelit tools however the client prefixes
# them, and nothing else.
python3 - "$(dirname "$GATE")/hooks.json" <<'EOF' || fail=1
import json, re, sys
matcher = json.load(open(sys.argv[1]))["hooks"]["PreToolUse"][0]["matcher"]
hit = ["mcp__plugin_limelit_limelit__publish_draft", "mcp__limelit__publish_draft",
       "mcp__limelit-local__reevaluate_all_prompts"]
miss = ["mcp__plugin_posthog_posthog__exec", "mcp__sentry__search_issues", "Bash", "Skill"]
bad = [n for n in hit if not re.search(matcher, n)] + [n for n in miss if re.search(matcher, n)]
if bad:
    print("FAIL matcher", matcher, "wrong on", bad)
    sys.exit(1)
EOF

if [[ $fail -eq 0 ]]; then echo "gate: all checks passed"; fi
exit $fail
