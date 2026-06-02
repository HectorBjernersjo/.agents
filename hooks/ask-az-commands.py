#!/usr/bin/env python3
import json
import re
import shlex
import sys


AZ_COMMAND_PATTERN = re.compile(
    r"""
    (?:^|[;&|]\s*|\n\s*)
    (?:
        [A-Za-z_][A-Za-z0-9_]*=\S+\s+
    )*
    (?:
        sudo\s+
    )?
    (?:
        env\s+(?:[A-Za-z_][A-Za-z0-9_]*=\S+\s+)*
    )?
    (?:[^\s;&|]+/)?
    az
    (?:\s|$|[;&|])
    """,
    re.VERBOSE,
)


def is_az_command(command: str) -> bool:
    try:
        parts = shlex.split(command)
    except ValueError:
        parts = command.split()

    if parts:
        executable = parts[0].split("/")[-1]
        if executable == "az":
            return True

    return AZ_COMMAND_PATTERN.search(command) is not None


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        print(json.dumps({"permission": "allow"}))
        return 0

    command = payload.get("command", "")

    if is_az_command(command):
        print(
            json.dumps(
                {
                    "permission": "ask",
                    "user_message": f"Azure CLI command requires confirmation: {command}",
                    "agent_message": "The Azure CLI command was flagged for user confirmation by a beforeShellExecution hook.",
                }
            )
        )
        return 0

    print(json.dumps({"permission": "allow"}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
