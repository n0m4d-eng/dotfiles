#!/bin/bash

# Function to convert names to lowercase with underscores instead of spaces
sanitize_name() {
    local name="$1"
    # Convert to lowercase and replace spaces with underscores
    # But preserve the extension by processing filename and extension separately
    echo "$name" | sed 's/ /_/g' | tr '[:upper:]' '[:lower:]'
}

# Check if directory parameter is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Check if the provided path is a valid directory
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a valid directory"
    exit 1
fi

target_dir="$1"

# Use find to process files and directories recursively
# We process in reverse depth-first order to handle nested items properly
find "$target_dir" -depth | while read -r item; do
    # Skip if it's the target directory itself
    if [ "$item" = "$target_dir" ]; then
        continue
    fi
    
    # Get the directory containing the item and the item's name
    parent_dir=$(dirname "$item")
    old_name=$(basename "$item")
    
    # Check if it's a file with an extension
    if [ -f "$item" ]; then
        # Split filename and extension
        filename="${old_name%.*}"
        extension="${old_name##*.}"
        
        # If filename equals extension (no dot or hidden file), treat as no extension
        if [ "$filename" = "$extension" ] || [ -z "$extension" ]; then
            # No extension or hidden file
            new_filename=$(sanitize_name "$old_name")
            new_name="$new_filename"
        else
            # Has extension - sanitize only the filename part
            new_filename=$(sanitize_name "$filename")
            new_name="${new_filename}.${extension}"
        fi
    else
        # It's a directory - sanitize the whole name
        new_name=$(sanitize_name "$old_name")
    fi
    
    # Only rename if the name actually changed
    if [ "$old_name" != "$new_name" ]; then
        new_path="${parent_dir}/${new_name}"
        
        # Check if target already exists
        if [ -e "$new_path" ]; then
            echo "Warning: Cannot rename '$item' to '$new_path' - target already exists"
        else
            echo "Renaming: '$item' -> '$new_path'"
            mv "$item" "$new_path"
        fi
    fi
done

echo "Renaming complete!"
