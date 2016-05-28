genrule(name = "echo",
        srcs = ["@io_bazel_rules_scala//:readme"],
        outs = ["localREADME.md"],
        cmd = "cat $(locations @io_bazel_rules_scala//:readme) > $@")
