#!/bin/bash

# Check if a filename is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <filename.c>"
    echo "Example: $0 main.c"
    exit 1
fi

C_FILE="$1"

# Check if the file exists and is a regular file
if [ ! -f "$C_FILE" ]; then
    echo "Error: File '$C_FILE' not found or is not a regular file."
    exit 1
fi

echo "--- Functions found in $C_FILE (Alphabetical Order) ---"
echo "-------------------------------------------------------"

# The core logic: finding and extracting function definitions
grep -E '^[a-zA-Z_][a-zA-Z0-9_* ]+\s+[a-zA-Z_][a-zA-Z0-9_]+\s*\(' "$C_FILE" | \
grep -vE '(if|for|while|switch|return|typedef|enum|struct|union)\s*\(' | \
sed -E 's/^\s*(static|const)\s+//g' | \
sed -E 's/^[a-zA-Z_][a-zA-Z0-9_* ]+\s+([a-zA-Z_][a-zA-Z0-9_]+)\s*\(.*/\1/' | \
sort -u
