def _clone_or_update(ctx):
  st = ctx.execute(["bash", '-c', """
set -ex
mkdir -p '{dir}'
cd '{dir}'
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  git clone '{remote}' .
fi
git fetch
git reset --hard {ref}
git clean -xdf
  """.format(
    dir=ctx.path("."),
    remote=ctx.attr.remote,
    ref=ctx.attr.ref,
  )])
  if st.return_code != 0:
    fail("error cloning %s:\n%s" % (ctx.name, st.stderr))

def _new_native_git_repository_implementation(ctx):
  _clone_or_update(ctx)
  if ctx.attr.build_file:
    ctx.symlink(ctx.attr.build_file, 'BUILD')
  else:
    ctx.file(ctx.attr.build_file_contents, 'BUILD')

def _native_git_repository_implementation(ctx):
  _clone_or_update(ctx)

new_native_git_repository=repository_rule(
  implementation=_new_native_git_repository_implementation,
  attrs={
    "remote": attr.string(mandatory=True),
    "ref": attr.string(default='master'),
    "build_file": attr.label(),
    "build_file_contents": attr.string(),
  }
)

native_git_repository=repository_rule(
  implementation=_native_git_repository_implementation,
  attrs={
    "remote": attr.string(mandatory=True),
    "ref": attr.string(default='master')
  }
)
