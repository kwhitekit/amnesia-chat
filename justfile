release:
  #!/usr/bin/env bash
  VERSION=$(just v)
  ### should be semver format (basic)
  if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo "The first line of ./VERSION.md has invalid version format: $VERSION"
    echo "Should be valid semver"
    echo "Thought it is ok to declare markdown heading. For example:\n# v1.0.2"
    exit 1
  fi
  ### Update package.json files
  for FILE in backend/deno.json frontend/package.json; do
    jq ".version=\"$VERSION\"" "$FILE" > tmp.$$.json && mv tmp.$$.json "$FILE"
  done
  echo "Version updated to $VERSION"
  just fmt
  git add -A
  git commit -m "RELEASE: v$(just v)"
  just tag

fmt:
  deno fmt --unstable-component --unstable-sql

alias default := ls
ls:
  just --list

alias v := version
version:
  #!/usr/bin/env bash
  head -n 1 ./VERSION.md | awk '{               
      sub(/#*\s*v?/, "");
      sub(/\s+.*/, "");
      print
    }'

tag:
  git tag -af v$(just v) --cleanup=verbatim -m "$(cat ./VERSION.md)"