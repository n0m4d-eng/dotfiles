#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

mkdir -p "$1"/{recon,exploits,notes,shells,loot}
touch "$1/report.md"
echo "Folder structure created in $1"
