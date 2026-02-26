#!/bin/bash

read -p "Enter the name of your note: " note_name

# Define the parent directory for the new note
parent_dir="$note_name"

# Create the parent directory and the .images directory within it
mkdir -p "$parent_dir/.images"

# Define the template content using a here document
read -r -d '' template_content <<'EOF'
---
title:
date started:
date completed
platform:
difficulty:
os:
tags:
---

# Scope

# Enumeration

## Ports

```bash
```

## Services

```bash
```

# Exploit

# Internal Enumeration

# Privilege Escalation

# Remediation

# Lessons Learnt
EOF

# Set the path for the new note file inside the parent directory
new_file="$parent_dir/$note_name.md"
echo "$template_content" > "$new_file"

# Create a temporary file for the keys
keys_file=$(mktemp)
# Extract keys from the template's frontmatter
echo "$template_content" | sed -n '/---/,/---/{/---/d;p;}' | cut -d: -f1 > "$keys_file"

while IFS= read -r key; do
    # Skip empty lines
    if [ -z "$key" ]; then
        continue
    fi

    # Trim leading/trailing whitespace
    key=$(echo "$key" | awk '{$1=$1};1')

    if [ "$key" == "date started" ]; then
        value=$(date +"%Y-%m-%d %H:%M:%S")
        echo "Setting 'date started' to: $value"
        sed -i '' "s/^$key:.*/$key: $value/" "$new_file"
    elif [ "$key" == "platform" ]; then
        echo "Choose a platform:"
        select platform in "HTB" "Offsec" "TryHackMe" "HackSmarter"; do
            if [ -n "$platform" ]; then
                value=$platform
                break
            else
                echo "Invalid selection. Please try again."
            fi
        done < /dev/tty # Read from terminal
        sed -i '' "s/^$key:.*/$key: $value/" "$new_file"
    else
        read -p "Enter value for '$key': " value < /dev/tty # Read from terminal
        sed -i '' "s/^$key:.*/$key: $value/" "$new_file"
    fi
done < "$keys_file"

rm "$keys_file"

echo "Created writeup note at: $new_file"
echo "Image directory created at: $parent_dir/.images"
