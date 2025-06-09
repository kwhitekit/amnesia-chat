alias default := ls
ls:
  just --list

release version:
  bash ./release.sh {{version}}

fmt:
  deno fmt --unstable-component --unstable-sql