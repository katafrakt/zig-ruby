const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addSharedLibrary("zig_rb", "src/main.zig", b.version(0, 0, 1));
    lib.setBuildMode(mode);

    // Ruby stuff
    var ruby_libdir = std.os.getenv("RUBY_LIBDIR") orelse "";
    lib.addLibraryPath(ruby_libdir);
    var ruby_hdrdir = std.os.getenv("RUBY_HDRDIR") orelse "";
    lib.addIncludePath(ruby_hdrdir);
    var ruby_archhdrdir = std.os.getenv("RUBY_ARCHHDRDIR") orelse "";
    lib.addIncludePath(ruby_archhdrdir);

    lib.linkSystemLibrary("c");
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
