#!/usr/bin/env python3
"""Filter install.conf.yaml for the current Dotbot profile.

A ``server: true`` marker runs only on the server profile, ``server: false``
runs only on the desktop profile, and omitting it runs on both. Markers work
at task level and per entry in ``link`` targets, ``shell`` items, ``unipkg``
packages, and ``create``/``clean`` targets. They are removed before Dotbot
sees the config, so they never become unknown directive options.
"""

import os
import sys
from pathlib import Path

import yaml


def read_marker(entry: dict, where: str) -> bool:
    value = entry.pop("server")
    if not isinstance(value, bool):
        raise ValueError(f"'server' must be true or false at {where}")
    return value


def filter_links(data, server: bool):
    if not isinstance(data, dict):
        return data
    kept = {}
    for destination, target in data.items():
        if isinstance(target, dict) and "server" in target:
            if read_marker(target, f"link {destination!r}") != server:
                continue
        kept[destination] = target
    return kept


def filter_shell(data, server: bool):
    if not isinstance(data, list):
        return data
    kept = []
    for index, item in enumerate(data):
        if isinstance(item, dict) and "server" in item:
            if read_marker(item, f"shell item {index}") != server:
                continue
        kept.append(item)
    return kept


def filter_targets(data, server: bool, directive: str):
    if not isinstance(data, dict):
        return data
    kept = {}
    for target, options in data.items():
        if isinstance(options, dict) and "server" in options:
            if read_marker(options, f"{directive} {target!r}") != server:
                continue
        kept[target] = options
    return kept


def filter_packages(entries, server: bool):
    if not isinstance(entries, list):
        return entries
    kept = []
    for entry in entries:
        if not isinstance(entry, dict):
            kept.append(entry)
            continue
        packages = {}
        for name, options in entry.items():
            if isinstance(options, dict) and "server" in options:
                if read_marker(options, f"unipkg package {name!r}") != server:
                    continue
            packages[name] = options
        if packages:
            kept.append(packages)
    return kept


def filter_unipkg(data, server: bool):
    if isinstance(data, dict):
        if "install" in data:
            data["install"] = filter_packages(data["install"], server)
        return data
    if isinstance(data, list):
        for item in data:
            if isinstance(item, dict) and "install" in item:
                item["install"] = filter_packages(item["install"], server)
        return data
    return data


def find_server_keys(value, path=()):
    if isinstance(value, dict):
        for key, child in value.items():
            if key == "server":
                yield " -> ".join(path) or "<task>"
            yield from find_server_keys(child, (*path, str(key)))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from find_server_keys(child, (*path, f"[{index}]"))


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} SOURCE DEST", file=sys.stderr)
        return 2

    source = Path(sys.argv[1])
    dest = Path(sys.argv[2])
    server = bool(os.environ.get("DOTFILES_SERVER"))

    config = yaml.safe_load(source.read_text(encoding="utf-8"))
    if not isinstance(config, list):
        print("config must be a YAML list of tasks", file=sys.stderr)
        return 1

    filtered = []
    try:
        for task in config:
            if isinstance(task, dict):
                if "server" in task and read_marker(task, "task") != server:
                    continue
                for directive, payload in task.items():
                    if directive == "link":
                        task[directive] = filter_links(payload, server)
                    elif directive == "shell":
                        task[directive] = filter_shell(payload, server)
                    elif directive == "unipkg":
                        task[directive] = filter_unipkg(payload, server)
                    elif directive in ("create", "clean"):
                        task[directive] = filter_targets(payload, server, directive)

                leftovers = list(find_server_keys(task))
                if leftovers:
                    print(
                        f"'server' marker not supported at: {', '.join(leftovers)}",
                        file=sys.stderr,
                    )
                    return 1
            if task:
                filtered.append(task)
    except ValueError as error:
        print(error, file=sys.stderr)
        return 1

    dest.write_text(yaml.safe_dump(filtered, sort_keys=False), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
