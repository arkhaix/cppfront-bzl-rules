# Bazel build file that provides build rules for the cppfront compiler and the
# utility library that is required by compiled .cpp2 -> .cpp files.

# Should be used in combination with the "new_local_repository" WORKSPACE rule
# so that the cpp2 generator rule can find the cppfront binary without pointing
# directly to the this path.

package(
    default_visibility = ["//visibility:public"],
)

COPTS = select({
    "@bazel_tools//src/conditions:windows": ["/std:c++latest"],
    "//conditions:default": ["--std=c++2a"],
})

cc_library(
    name = "cpp2util",
    hdrs = ["include/cpp2util.h", "source/build.info"],
    includes = ["include/", "source/"],
)

cc_binary(
    name = "cppfront",
    srcs = glob(["source/*.cpp"]) + glob(["source/*.h"]),
    deps = ["cpp2util"],
    copts = COPTS,
)
