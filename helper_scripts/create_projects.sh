#!/bin/bash

read -p "Enter the project name: " project_name

if [ -z "$project_name" ]; then
  echo "Project name cannot be empty."
  exit 1
fi

mkdir -p "$project_name"/{recon,exploits,loot,writeup/.images}
echo "Folder structure created in $project_name"

read -r -d '' template_content <<'EOF'
---
title:
date started:
date completed:
platform:
difficulty:
os:
tags:
---

# Scope

# Enumeration

# Exploit

# Internal Enumeration

# Privilege Escalation

# Remediation

# Lessons Learnt
EOF

new_file="$project_name/writeup/$project_name.md"
echo "$template_content" > "$new_file"

keys_file=$(mktemp)
echo "$template_content" | sed -n '/---/,/---/{/---/d;p;}' | cut -d: -f1 > "$keys_file"

while IFS= read -r key; do
    if [ -z "$key" ]; then
        continue
    fi

    key=$(echo "$key" | awk '{$1=$1};1')

    if [ "$key" == "date started" ]; then
        value=$(date +"%Y-%m-%d %H:%M:%S")
        echo "Setting 'date started' to: $value"
        sed -i.bak "s/^$key:.*/$key: $value/" "$new_file" && rm -f "${new_file}.bak"
    elif [ "$key" == "platform" ]; then
        echo "Choose a platform:"
        select platform in "HTB" "Offsec" "TryHackMe" "HackSmarter"; do
            if [ -n "$platform" ]; then
                value=$platform
                break
            else
                echo "Invalid selection. Please try again."
            fi
        done < /dev/tty
        sed -i.bak "s/^$key:.*/$key: $value/" "$new_file" && rm -f "${new_file}.bak"
    else
        read -p "Enter value for '$key': " value < /dev/tty
        sed -i.bak "s/^$key:.*/$key: $value/" "$new_file" && rm -f "${new_file}.bak"
    fi
done < "$keys_file"

rm "$keys_file"

echo "Writeup note created at: $new_file"
echo "Image directory created at: $project_name/writeup/.images"
