#!/bin/sh
echo -ne '\033c\033]0;TinyCreatures\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/TinyBusters.x86_64" "$@"