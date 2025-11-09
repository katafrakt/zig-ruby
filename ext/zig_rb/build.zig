const std = @import("std");

pub fn build(b: *std.Build) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("zig_rb", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .root_module = mod,
        .name = "zig_rb",
        .version = .{ .major = 0, .minor = 0, .patch = 1 },
        .linkage = .dynamic,
    });

    // Ruby stuff
    const ruby_libdir = std.posix.getenv("RUBY_LIBDIR") orelse try system_ruby_libdir(b);
    lib.addLibraryPath(std.Build.LazyPath{ .cwd_relative = ruby_libdir });
    const ruby_hdrdir = std.posix.getenv("RUBY_HDRDIR") orelse try system_ruby_hdrdir(b);
    lib.addIncludePath(std.Build.LazyPath{ .cwd_relative = ruby_hdrdir });
    const ruby_archhdrdir = std.posix.getenv("RUBY_ARCHHDRDIR") orelse try system_ruby_archhdrdir(b);
    lib.addIncludePath(std.Build.LazyPath{ .cwd_relative = ruby_archhdrdir });

    lib.linkSystemLibrary("c");
    b.installArtifact(lib);

    //    const main_tests = b.addTest("src/main.zig");
    //    main_tests.setBuildMode(mode);

    //    const test_step = b.step("test", "Run library tests");
    //    test_step.dependOn(&main_tests.step);
}

fn system_ruby_libdir(b: *std.Build) ![]const u8 {
    const libdir_step = b.step("Get Ruby libdir", "Get Ruby library path");
    return try libdir_step.evalChildProcess(&[_][]const u8{ "ruby", "-e", "puts RbConfig::CONFIG['libdir']" });
}

fn system_ruby_hdrdir(b: *std.Build) ![]const u8 {
    const hdrdir_step = b.step("Get Ruby rubyhdrdir", "Get Ruby hdr path");
    return try hdrdir_step.evalChildProcess(&[_][]const u8{ "ruby", "-e", "puts RbConfig::CONFIG['rubyhdrdir']" });
}

fn system_ruby_archhdrdir(b: *std.Build) ![]const u8 {
    const archhdrdir_step = b.step("Get Ruby rubyarchhdrdir", "Get Ruby archhdr path");
    return try archhdrdir_step.evalChildProcess(&[_][]const u8{ "ruby", "-e", "puts RbConfig::CONFIG['rubyarchhdrdir']" });
}
