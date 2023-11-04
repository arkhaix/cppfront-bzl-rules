load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//rules:run_binary.bzl", "run_binary")

def cpp2_library(name, cppfront_flags = [], srcs = [], **kwargs):
    """Like cc_library, but for .cpp2 files

    This is a simple macro that takes .cpp2 files, runs them through cppfront,
    then sticks the resulting files in a cc_library.

    cppfront_flags: Flags to stick in the cppfront command line
    srcs: .cpp2 files to compile into C++ files
    All other arguments are passed into the cc_library rule.
    """

    cc_files = []
    for s in srcs:
        cc_file = paths.split_extension(s)[0] + ".cpp"
        cc_files += [cc_file]
        run_binary(
            name = name + "_rb_" + cc_file,
            args = cppfront_flags + [s, "-output", "$(location {})".format(cc_file)],
            srcs = [s],
            outs = [cc_file],
            tool = "@cppfront//:cppfront",
        )

    native.cc_library(
        name = name,
        srcs = cc_files,
        deps = ["@cppfront//:cpp2util"] + kwargs.get("deps", default = []),
        **kwargs
    )
