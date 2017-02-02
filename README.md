# DEPRECATED -- Implementation of bazel git repositories using Skylark Repository rules

This repository has been
[upstreamed into bazel](https://github.com/bazelbuild/bazel/issues/1408),
and is now deprecated. I am keeping it up in case any existing build
rules depend on this path, but users should migrate.

# Old README contents

This repository reimplements Bazel's `git_repository` and
`new_git_repository` rules using Skylark repository functions to shell
out to the system git.

Shelling out to the `git` binary gets us support for ssh clones, which
the built-in support doesn't include.

The functions in this repository are currently called
`native_git_repository` and `new_native_git_repository`, where
"native" is meant to connote "the system-native `git`
implementation". The names are subject to change.

These rules currently require bazel `0.2.1` or newer. As of this
writing, `0.2.1` is in rc and rc1 can be downloaded from
https://storage.googleapis.com/bazel/0.2.1/rc1/index.html

## Usage

Add the following code to your `WORKSPACE` file:

```python
git_repository(
    name = "com_github_nelhage_bazel_git_repositories",
    remote = "https://github.com/nelhage/bazel_git_repositories",
    tag = "v2",
)

load(
    "@com_github_nelhage_bazel_git_repositories//:repositories.bzl",
    "new_native_git_repository",
    "native_git_repository",
)
```

Then you should be able to use `native_git_repository` and `new_native_git_repository` rules:

```python
native_git_repository(
    name = "my_repository",
    remote = "git@github.com:MyAccount/my_repository.git",
    commit = "master",
)

new_native_git_repository(
	name = "my_other_repository",
	remote = "git@github.com:MyAccount/my_other_repository.git"
	build_file = "my_other_repository.BUILD",
    tag = "v1.1",
)
```
