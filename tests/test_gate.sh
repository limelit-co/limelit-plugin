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

if [[ $fail -eq 0 ]]; then echo "gate: all checks passed"; fi
exit $fail
