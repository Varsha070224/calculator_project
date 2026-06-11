import ast
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
                tree = ast.parse(f.read())

            for node in ast.walk(tree):
                if isinstance(node, ast.FunctionDef):
                    if ast.get_docstring(node) is None:
                        print(
                            f"Missing docstring in "
                            f"{path}:{node.lineno} "
                            f"({node.name})"
                        )
                        failed = True

if failed:
    sys.exit(1)

