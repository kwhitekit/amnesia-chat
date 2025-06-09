# amnesia-chat

Dead simple chat with no memory and no authentication. Connect, talk, enjoy the
moment — nothing is stored, ever.

## Project specifics _(most of them primarily not-related to code)_

- the `just` cli program is used for flexible and rich task management
- to update version the `just release` helper command can be used

## Git flow

- as base schema the `github flow` is used
- ~~though it is extended by `release` management (not branches but tagging)~~
- the feature branches created before<sub>but not included to</sub> tag should
  be rebase `main` so it will be appeared after release in timeline
- so yes, the main extension of standard github flow is strict and sync tagging
  _(it will be used for better explicit deployments)_

#### Git - Github integration requirements

- restrict to `tag` creation from github
  - the tag should be created programmatically - so the sync between tag and
    version can be guarantied
  - the release creation because is required to be attached to some tag will
    always be of specific **valid** version

#### General details

- **no environment branches at all**
- the `main` branch is the single and final source of truth
- the environment is configured via github environment feature
- the releases are used as time traveling for deployments
- the pull requests are used as the main point for any ci/cd task and so as
  replacement for any release branches and so on

#### Open questions:

1. Should any infinite branch except `main` to be exists? _(for example `dev`)_

- No.
  - _(because there are not any concrete benefits of this, though it is still
    looked more natural)_

2. Should `main` branch use **rebase** or **squash** features?

- May be.
  - _(for clean history it is good idea but do this only if it is easy, this
    should not be the important goal)_
  - in any case each commit on `main` **should be deployable** and **save to
    make branch from it**
  - for clean history purposes and more explicit deploy control the release git
    feature with integration of github actions and so on will be used

3. Should feature-like branches have own aka private lifecycle? _(for example
   own children for detailed history with squash merging)_
   - May be.
     - Until this is local branch - you can manage it as you wish, but after
       push - the destructive actions should be avoided _(aka rebase or amend)_
     - So for clean history purposes you may create `local draft child` from
       `feature` and then make squash to `feature` before pr to `main`
     - May be some extra rule should be defined, that will allow mark feature
       branch aka _closed to updates_ and so it will be possible for example do
       something destructive with it
     - The example for above line - make locally merge conflicts via rebase from
       `main` and then make **push --force** to origin feature. So pr conflicts
       will be resolved, the beauty linear history also preserved.
     - P.S. again - it will not be problematic if only all team of this feature
       branch will somehow understand that it is closed to updated
4. Should each pr to `main` have been initiate release creation? _(obviously not
   but why not)_
   - No.
     - As mentioned earlier, no matter will be releases or not - each commit on
       main should be deployable, safe to make new branch from, pass all tests
       or something like that
     - So the main purpose of releases is to mark more explicitly points of
       deploys and easy way to make _time travel_ possibility between deploy
       versions
5. Synchronization of feature branches

- Nothing special is required
  - First of all this flow should eliminate requirement of sync between features
    via often updates. In other words - the huge updates, feature are not
    typical for this flow.
  - As one of the possible _(obvious, nothing special)_ solution - is to make pr
    to `main` via first feature, and then update second one. Or even at once
    merge first to second and so then make pr `main <= second` that will be
    already contain `first`
  - And again - though each commit on main is deployable it doesn't mean that
    deploy will be happen. So make first pr, make second, make deploy.

6. The mechanism of the version updating _(the part of code, that is store
   version info)_. How it should be done technically? At which moment and on
   which branch it should be happen?
   - The _bump_ commit should be created before release creation
   - It should be automated
   - TODO: create `release.yml` github action with this logic

## Backend

- Top level Hono server
- Internally integrated with apollo server

#### Problems

- the library level type mismatch between apollo server and as-integration _(one
  of them use cjs instead of esm type import declaration)_
- possible missing of the request context on the integration edge
