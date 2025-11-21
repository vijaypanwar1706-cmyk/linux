#!/bin/bash

TARGET="${1:-.}"

find "$TARGET" -type f -name "*.c" | while read -r file; do
    echo "Processing $file"

    tmp_clean=$(mktemp)
    tmp_out=$(mktemp)

    # Reformat for predictable brace layout
    indent -st -br -bli0 -i4 -nut "$file" > "$tmp_clean"

    in_func=0
    printed=0
    last_line=""

    while IFS= read -r line; do

        # Detect function header:
        # Ends with ')' AND does NOT contain '='  (skip struct initializers)
        if echo "$line" | grep -qE '\)\s*$' && ! echo "$line" | grep -q '='; then
            in_func=1
            printed=0
        fi

        # Output current line
        echo "$line" >> "$tmp_out"

        # Detect opening brace
        if echo "$line" | grep -q '{'; then

            # Skip if this is struct/array initializer
            if echo "$last_line" | grep -q '=' || echo "$line" | grep -q '='; then
                in_func=0
                last_line="$line"
                continue
            fi

            # Insert printk when inside function & not already inserted
            if [ "$in_func" -eq 1 ] && [ "$printed" -eq 0 ]; then
                echo "    printk(KERN_INFO \"%s:%s(): reached here\\n\", __FILE__, __func__);" >> "$tmp_out"
                echo "    ; /* avoid -Wswitch-unreachable */" >> "$tmp_out"
                printed=1
                in_func=0
            fi
        fi

        last_line="$line"

    done < "$tmp_clean"

    mv "$tmp_out" "$file"
    rm -f "$tmp_clean"

done

