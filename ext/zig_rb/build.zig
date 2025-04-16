const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{ .name = "zig_rb", .root_source_file = .{ .path = "src/main.zig" }, .version = .{ .major = 0, .minor = 0, .patch = 1 }, .optimize = optimize, .target = target });

    // Ruby stuff
    const ruby_libdir = std.posix.getenv("RUBY_LIBDIR") orelse "";
    lib.addLibraryPath(.{ .path = ruby_libdir });
    const ruby_hdrdir = std.posix.getenv("RUBY_HDRDIR") orelse "";
    lib.addIncludePath(.{ .path = ruby_hdrdir });
    const ruby_archhdrdir = std.posix.getenv("RUBY_ARCHHDRDIR") orelse "";
    lib.addIncludePath(.{ .path = ruby_archhdrdir });

    lib.linkSystemLibrary("c");
    b.installArtifact(lib);

    //    const main_tests = b.addTest("src/main.zig");
    //    main_tests.setBuildMode(mode);

    //    const test_step = b.step("test", "Run library tests");
    //    test_step.dependOn(&main_tests.step);
}
