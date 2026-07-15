# Track PART 5 as an isolated subproject

PART 5 modifies `jitsm555/Flutter-MVVM`, which is a separate legacy Flutter
application rather than a feature of the equipment-loan app. Track a cleaned
copy at `part5_flutter_mvvm/`, pinned to upstream commit
`959c25e5c07454e33de8473c6ed0ce494b06f227`, and perform the work on
`codex/part-5-mvvm` so its compatibility changes and MVVM decisions remain
separate from PARTs 1-4 while still being reproducible from this repository.

## Consequences

The imported copy excludes its nested `.git`, `build`, `.dart_tool`, and IDE
artifacts. Another AI agent owns PART 5 implementation, evidence, commit, and
tag. Whether to retain and modernize the legacy audio player is deliberately
deferred until that agent reproduces the compatibility problem on the pinned
source.

