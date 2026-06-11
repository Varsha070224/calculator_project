#!/bin/bash

FILES_CHANGED=$(git diff --name-only HEAD~1 HEAD | wc -l)

STATS=$(git diff --shortstat HEAD~1 HEAD)

ADDED=$(echo "$STATS" | grep -o '[0-9]* insertion' | grep -o '[0-9]*')
REMOVED=$(echo "$STATS" | grep -o '[0-9]* deletion' | grep -o '[0-9]*')

ADDED=${ADDED:-0}
REMOVED=${REMOVED:-0}

echo "## Automated PR Review" > review.md
echo "" >> review.md
echo "- Files Changed: $FILES_CHANGED" >> review.md
echo "- Lines Added: $ADDED" >> review.md
echo "- Lines Removed: $REMOVED" >> review.md
echo "" >> review.md

echo "### TODO / FIXME" >> review.md
echo "" >> review.md

FOUND=0

for file in $(git diff --name-only HEAD~1 HEAD)
do
  if [ -f "$file" ]; then
    RESULT=$(grep -nE "TODO|FIXME" "$file")

    if [ ! -z "$RESULT" ]; then
      echo "#### $file" >> review.md
      echo '```' >> review.md
      echo "$RESULT" >> review.md
      echo '```' >> review.md
      FOUND=1
    fi
  fi
done

if [ $FOUND -eq 0 ]; then
  echo "No TODO/FIXME found." >> review.md
fi

echo "" >> review.md
echo "### Diff Statistics" >> review.md
echo "" >> review.md
echo '```' >> review.md
git diff --stat HEAD~1 HEAD >> review.md
echo '```' >> review.md
