def _clone_or_update(ctx):
  if ((ctx.attr.tag == "" and ctx.attr.commit == "") or
      (ctx.attr.tag != "" and ctx.attr.commit != "")):
    ctx.fail("Exactly one of commit and tag must be provided")
  if ctx.attr.commit != "":
    ref = ctx.attr.commit
  else:
    ref = "tags/" + ctx.attr.tag

  st = ctx.execute(["bash", '-c', """
set -ex
if ! ( cd '{dir}' && git rev-parse --git-dir ) >/dev/null 2>&1; then
  rm -rf '{dir}'
  git clone '{remote}' '{dir}'
fi
cd '{dir}'
git fetch
git reset --hard {ref}
git clean -xdf
  """.format(
    dir=ctx.path("."),
    remote=ctx.attr.remote,
    ref=ref,
  )])
  if st.return_code != 0:
    fail("error cloning %s:\n%s" % (ctx.name, st.stderr))

def _new_native_git_repository_implementation(ctx):
  _clone_or_update(ctx)
  if ctx.attr.build_file:
    ctx.symlink(ctx.attr.build_file, 'BUILD')
  else:
    ctx.file('BUILD', ctx.attr.build_file_contents)

def _native_git_repository_implementation(ctx):
  _clone_or_update(ctx)


_common_attrs = {
  "remote": attr.string(mandatory=True),
  "commit": attr.string(default=""),
  "tag": attr.string(default=""),
}


new_native_git_repository=repository_rule(
  implementation=_new_native_git_repository_implementation,
  attrs=_common_attrs + {
    "build_file": attr.label(),
    "build_file_contents": attr.string(),
  }
)

native_git_repository=repository_rule(
  implementation=_native_git_repository_implementation,
  attrs=_common_attrs,
)
