#!/bin/bash
set -e

VERSION=$1
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi

# Validate semver format (basic)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid version format: $VERSION"
  exit 1
fi

# Read current version from VERSION file (if exists)
if [[ -f VERSION ]]; then
  CURRENT_VERSION=$(head -n 1 VERSION)
else
  CURRENT_VERSION="0.0.0"
fi

# Compare versions
if [ "$(printf '%s\n' "$VERSION" "$CURRENT_VERSION" | sort -V | head -n1)" != "$CURRENT_VERSION" ]; then
  echo "New version ($VERSION) must be greater or equal to current version ($CURRENT_VERSION)"
  exit 1
fi

# Update VERSION file
echo "$VERSION" > VERSION

# Update package.json files
for FILE in backend/deno.json frontend/package.json; do
  jq ".version=\"$VERSION\"" "$FILE" > tmp.$$.json && mv tmp.$$.json "$FILE"
done

echo "Version updated to $VERSION in VERSION file and package.json files (no commit done)"

git tag -a $VERSION -F ./VERSION