# Implementation of bazel git repositories using Skylark Repository rules

This repository reimplements Bazel's `git_repository` and
`new_git_repository` rules using Skylark repository functions to shell
out to the system git.

Shelling out to the `git` binary gets us support for ssh clones, which
the built-in support doesn't include.

The functions in this repository are currently called
`native_git_repository` and `new_native_git_repository`, where
"native" is meant to connote "the system-native `git`
implementation". The names are subject to change.
