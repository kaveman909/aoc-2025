const std = @import("std");
const debug = std.debug;
const mem = std.mem;
//const fmt = std.fmt;
//const math = std.math;
//const expect = std.testing.expect;

pub fn run() !void {
    const input = @embedFile("input/day3.txt");

    var it_range = mem.splitAny(u8, input, "\n");
    while (it_range.next()) |i| {
        debug.print("{s}\n", .{i});
        var batteries = mem.reverseIterator(i);
        const last_battery = batteries.next().?;
        while (batteries.next()) |j| {
            debug.print("{}, ", .{j - 48});
        }
        debug.print("last: {}\n", .{last_battery - 48});
    }
}
