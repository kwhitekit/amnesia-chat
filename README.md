# Backend

- Top level Hono server
- Internally integrated with apollo server

### Problems

- the library level type mismatch between apollo server and as-integration _(one
  of them use cjs instead of esm type import declaration)_
- possible missing of the request context on the integration edge
