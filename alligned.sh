#!/bin/bash

TARGET="${1:-./testfiles}"
INTERVAL=5

MAX_TOTAL=0

while true; do
    OUTPUT=$(hs usage alignment "$TARGET")

    ALIGNED=$(echo "$OUTPUT" | awk '
        /ALIGNMENT\('\''ALIGNED'\''\)/ { found=1; next }
        found && /VALUE/ {
            split($0,a,"=")
            gsub(/[;[:space:]]/,"",a[2])
            printf "%.0f\n", a[2] + 0
            exit
        }
    ')

    PARTIAL=$(echo "$OUTPUT" | awk '
        /ALIGNMENT\('\''PARTIALLY ALIGNED'\''\)/ { found=1; next }
        found && /VALUE/ {
            split($0,a,"=")
            gsub(/[;[:space:]]/,"",a[2])
            printf "%.0f\n", a[2] + 0
            exit
        }
    ')

    ALIGNED=${ALIGNED:-0}
    PARTIAL=${PARTIAL:-0}

    CURRENT_TOTAL=$((ALIGNED + PARTIAL))

    if (( CURRENT_TOTAL > MAX_TOTAL )); then
        MAX_TOTAL=$CURRENT_TOTAL
    fi

    if (( MAX_TOTAL == 0 )); then
        printf "%s Waiting for files to appear in Hammerspace statistics...\n" \
            "$(date '+%Y-%m-%d %H:%M:%S')"
        sleep "$INTERVAL"
        continue
    fi

    PERCENT=$(awk -v a="$ALIGNED" -v t="$MAX_TOTAL" \
        'BEGIN { printf "%.1f", (a/t)*100 }')

    printf "%s Aligned: %d/%d files (%s%%)\n" \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$ALIGNED" "$MAX_TOTAL" "$PERCENT"

    if (( ALIGNED >= MAX_TOTAL )); then
        printf "%s All files aligned.\n" \
            "$(date '+%Y-%m-%d %H:%M:%S')"
        exit 0
    fi

    sleep "$INTERVAL"
done