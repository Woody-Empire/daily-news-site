#!/bin/bash
# Generate content/index.json by scanning content directories for .html files

CONTENT_DIR="$(cd "$(dirname "$0")/../content" && pwd)"
OUTPUT="$CONTENT_DIR/index.json"

echo "{" > "$OUTPUT"

first_cat=true
for dir in "$CONTENT_DIR"/*/; do
  [ -d "$dir" ] || continue
  cat_name=$(basename "$dir")

  $first_cat || echo "," >> "$OUTPUT"
  first_cat=false

  printf '  "%s": [' "$cat_name" >> "$OUTPUT"

  # Collect dates from .html filenames, sorted descending
  dates=$(ls "$dir"*.html 2>/dev/null | xargs -I{} basename {} .html | sort -r)

  first_date=true
  for d in $dates; do
    $first_date || printf ',' >> "$OUTPUT"
    first_date=false
    printf '\n    "%s"' "$d" >> "$OUTPUT"
  done

  [ "$first_date" = true ] || printf '\n  ' >> "$OUTPUT"
  printf ']' >> "$OUTPUT"
done

echo "" >> "$OUTPUT"
echo "}" >> "$OUTPUT"

echo "Generated $OUTPUT"
