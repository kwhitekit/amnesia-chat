export JSON_FILES_WITH_VERSION := 'backend/deno.json frontend/package.json'

default:
    @just --choose

release:
    #!/usr/bin/env bash
    VERSION=$(just v)
    ### should be semver format (basic)
    if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
      echo "The first line of ./VERSION.md should be valid semver version format (markdown heading allowed): $VERSION"
      exit 1
    fi
    ### Update package.json files
    for FILE in {{ JSON_FILES_WITH_VERSION }}; do
      jq ".version=\"$VERSION\"" "$FILE" > tmp.$$.json && mv tmp.$$.json "$FILE"
    done
    echo "Version updated to $VERSION"
    just fmt
    git add -A
    git commit -m "RELEASE: v$(just v)"
    just tag

fmt:
    just --fmt --unstable
    deno fmt --unstable-component --unstable-sql

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
