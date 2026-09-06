#!/bin/bash
set -e

SRC="/workspace/course/configs"
DST="/workspace/chipyard/generators/chipyard/src/main/scala/config"

if [ ! -d "$SRC" ]; then
    echo "Course configuration directory not found: $SRC"
    exit 1
fi

echo "Linking course Chipyard configurations..."

for file in "$SRC"/*.scala; do
    if [ -e "$file" ]; then
        name=$(basename "$file")

        ln -sf "$file" "$DST/$name"

        echo "  $name"
    fi
done

echo "Course configurations ready."