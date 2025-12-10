const std = @import("std");

pub fn run() !void {
    const input = @embedFile("input/day2.txt");
    std.debug.print("Input: {s}\n", .{input});
}
