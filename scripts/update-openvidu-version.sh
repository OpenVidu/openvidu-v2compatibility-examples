#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 3.6.0"
    exit 1
fi

NEW_VERSION="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
EXAMPLES_DIR="$REPO_ROOT/examples"

if [ ! -d "$EXAMPLES_DIR" ]; then
    echo "Error: examples/ directory not found at $EXAMPLES_DIR"
    exit 1
fi

updated_packages=()
updated_html=()

for example_dir in "$EXAMPLES_DIR"/*/; do
    example_name="$(basename "$example_dir")"

    # Update openvidu-node-client-v2compatibility version in package.json
    pkg="$example_dir/package.json"
    if [ -f "$pkg" ]; then
        if grep -q '"openvidu-node-client-v2compatibility"' "$pkg"; then
            sed -i "s/\"openvidu-node-client-v2compatibility\": \"[^\"]*\"/\"openvidu-node-client-v2compatibility\": \"$NEW_VERSION\"/" "$pkg"
            updated_packages+=("$example_name/package.json")
        fi
    fi

    # Update openvidu-browser-v2compatibility script URL in HTML files under public/
    if [ -d "$example_dir/public" ]; then
        for html_file in "$example_dir"/public/*.html; do
            [ -f "$html_file" ] || continue
            if grep -q 'openvidu-browser-v2compatibility' "$html_file"; then
                # Update the version in the GitHub releases download path: v{OLD} -> v{NEW}
                # and the filename: openvidu-browser-v2compatibility-{OLD}.min.js -> {NEW}.min.js
                sed -i "s|releases/download/v[0-9][0-9.]*/openvidu-browser-v2compatibility-[0-9][0-9.]*.min.js|releases/download/v$NEW_VERSION/openvidu-browser-v2compatibility-$NEW_VERSION.min.js|g" "$html_file"
                updated_html+=("$example_name/public/$(basename "$html_file")")
            fi
        done
    fi
done

# Regenerate package-lock.json for updated examples
for f in "${updated_packages[@]}"; do
    dir="$EXAMPLES_DIR/$(dirname "$f")"
    echo "Running npm install in $dir..."
    (cd "$dir" && npm install)
done

echo ""
echo "Updated to version $NEW_VERSION:"
echo ""
if [ ${#updated_packages[@]} -gt 0 ]; then
    echo "  package.json files:"
    for f in "${updated_packages[@]}"; do
        echo "    - $f"
    done
fi
if [ ${#updated_html[@]} -gt 0 ]; then
    echo "  HTML files:"
    for f in "${updated_html[@]}"; do
        echo "    - $f"
    done
fi
if [ ${#updated_packages[@]} -eq 0 ] && [ ${#updated_html[@]} -eq 0 ]; then
    echo "  No files were updated."
fi
