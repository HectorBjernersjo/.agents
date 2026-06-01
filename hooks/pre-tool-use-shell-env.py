#!/usr/bin/env python3

import json
import sys


ENV_SCRIPT = "/home/hector/.agents/hooks/agent-shell-env.sh"
MARKER = "# cursor-agent-env-hook"


def main() -> None:
    payload = json.load(sys.stdin)
    if payload.get("tool_name") != "Shell":
        print(json.dumps({"permission": "allow"}))
        return

    tool_input = dict(payload.get("tool_input") or {})
    command = tool_input.get("command")
    if not isinstance(command, str) or not command.strip() or MARKER in command:
        print(json.dumps({"permission": "allow"}))
        return

    tool_input["command"] = (
        f'if [ -f "{ENV_SCRIPT}" ]; then source "{ENV_SCRIPT}"; fi\n'
        f"{MARKER}\n"
        f"{command}"
    )
    print(json.dumps({"permission": "allow", "updated_input": tool_input}))


if __name__ == "__main__":
    main()
