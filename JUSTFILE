export files_with_version := 'backend/deno.json frontend/package.json'

release:
  #!/usr/bin/env bash
  VERSION=$(just v)
  ### should be semver format (basic)
  if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo "The first line of ./VERSION.md should be valid semver version format (markdown heading allowed): $VERSION"
    exit 1
  fi
  ### Update package.json files
  for FILE in {{ files_with_version }}; do
    jq ".version=\"$VERSION\"" "$FILE" > tmp.$$.json && mv tmp.$$.json "$FILE"
  done
  echo "Version updated to $VERSION"
  just fmt
  git add -A
  git commit -m "RELEASE: v$(just v)"
  just tag

fmt:
  deno fmt --unstable-component --unstable-sql

default:
  @just --choose

alias v := version
version:
  #!/usr/bin/env bash
  head -n 1 ./VERSION.md | awk '{               
      sub(/#*\s*v?/, "");
      sub(/\s+.*/, "");
      print
    }'

tag:
  git tag -af v$(just v) --cleanup=whitespace -m "$(cat ./VERSION.md)"