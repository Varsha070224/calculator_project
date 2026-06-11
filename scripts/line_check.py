import os
import sys

failed = False

for root, dirs, files in os.walk("."):
    if ".git" in root:
        continue

    for file in files:
        if file.endswith(".py"):
            path = os.path.join(root, file)

            with open(path, "r", encoding="utf-8") as f:
                line_count = len(f.readlines())

            print(f"{path}: {line_count} lines")

            if line_count > 100:
                print(f"ERROR: {path} exceeds 100 lines")
                failed = True

if failed:
    sys.exit(1)
