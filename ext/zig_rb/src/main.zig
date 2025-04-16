const std = @import("std");
const ruby = @cImport(@cInclude("ruby/ruby.h"));
const testing = std.testing;

// Calculate number of open doors after N passes
// Code taken from Rosetta Code: https://rosettacode.org/wiki/100_doors#Zig
fn hundred_doors(passes: c_int) c_int {
    var doors = [_]bool{false} ** 101;
    var pass: u8 = 1;
    var door: u8 = undefined;
    
    while (pass <= passes) : (pass += 1) {
        door = pass;
        while (door <= 100) : (door += pass)
            doors[door] = !doors[door];
    }
    
    var num_open: u8 = 0;
    for (doors) |open| {
        if (open) 
            num_open += 1;
    }
    return num_open;
}

// This is a wrapper for hundred_doors function to make it work with Ruby.
fn rb_hundred_doors(...) callconv(.C) ruby.VALUE {
    var ap = @cVaStart();
    defer @cVaEnd(&ap);

    // first argument is `self`, but we don't use it so we need to discard it
    const self = @cVaArg(&ap, ruby.VALUE);
    _ = self;

    // back and forth conversion from Ruby types to internal types + delegation to
    // actual `hundred_doors` function
    const passes = ruby.NUM2INT(@cVaArg(&ap, ruby.VALUE));
    return ruby.INT2NUM(hundred_doors(passes));
}

export fn Init_libzig_rb() void {
    const zig_rb_class: ruby.VALUE = ruby.rb_define_class("ZigRb", ruby.rb_cObject);
    _ = ruby.rb_define_method(zig_rb_class, "hundred_doors", rb_hundred_doors, 1);
}

test "hundred doors 100 passes" {
    try testing.expect(hundred_doors(100) == 10);
}

test "hundred_doors 1 pass" {
    try testing.expect(hundred_doors(1) == 100);
}
