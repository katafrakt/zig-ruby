const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{ .name = "zig_rb", .root_source_file = .{ .path = "src/main.zig" }, .version = .{ .major = 0, .minor = 0, .patch = 1 }, .optimize = optimize, .target = target });

    // Ruby stuff
    var ruby_libdir = std.os.getenv("RUBY_LIBDIR") orelse "";
    lib.addLibraryPath(.{ .path = ruby_libdir });
    var ruby_hdrdir = std.os.getenv("RUBY_HDRDIR") orelse "";
    lib.addIncludePath(.{ .path = ruby_hdrdir });
    var ruby_archhdrdir = std.os.getenv("RUBY_ARCHHDRDIR") orelse "";
    lib.addIncludePath(.{ .path = ruby_archhdrdir });

    lib.linkSystemLibrary("c");
    b.installArtifact(lib);

    //    const main_tests = b.addTest("src/main.zig");
    //    main_tests.setBuildMode(mode);

    //    const test_step = b.step("test", "Run library tests");
    //    test_step.dependOn(&main_tests.step);
}
