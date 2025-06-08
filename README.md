# amnesia-chat

Dead simple chat with no memory and no authentication. Connect, talk, enjoy the
moment — nothing is stored, ever.

## Git flow

- as base schema the `github flow` is used
- though it is extended by `release` management (not branches but tagging)
- the feature branches created before release should be merge `main` with
  rebasing

#### Details

- no environment branches at all
- the `main` branch is the single and final source of truth
- the environment is configured via github environment feature
- the releases are used as time traveling for deployments
- the pull requests are used as the main point for any ci/cd task and so as
  replacement for any release branches and so on

#### Open questions:

1. Should any infinite branch except `main` to be exists? _(for example `dev`)_
2. Should `main` branch use **rebase** or **squash** features?
3. Should feature-like branches have own aka private lifecycle? _(for example
   own children for detailed history with squash merging)__
4. Should each pr to `main` have been initiate release creation? _(obviously not
   but why not)_
5. Synchronization of feature branches
6. The mechanism of the version updating _(the part of code, that is store
   version info)_. How it should be done technically? At which moment and on
   which branch it should be happen?

## Backend

- Top level Hono server
- Internally integrated with apollo server

#### Problems

- the library level type mismatch between apollo server and as-integration _(one
  of them use cjs instead of esm type import declaration)_
- possible missing of the request context on the integration edge
