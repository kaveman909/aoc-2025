const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const testing = std.testing;
const expect = std.testing.expect;

pub fn run() !void {
    const input = @embedFile("input/day7.txt");
    const N_COLS = 141;

    var grid_in = mem.splitAny(u8, input, "\n");
    var cur_row: [N_COLS]u8 = undefined;
    var above_row: [N_COLS]u8 = undefined;
    var split_count: u64 = 0;
    @memcpy(&above_row, grid_in.first()[0..N_COLS]);

    while (grid_in.next()) |row| {
        for (row, 0..) |cell, i| {
            if (cell == '.') {
                if (cur_row[i] == '|' or above_row[i] == '|') {
                    cur_row[i] = '|';
                } else {
                    cur_row[i] = '.';
                }
            } else if (cell == '^') {
                if (above_row[i] == '|') {
                    cur_row[i - 1] = '|';
                    cur_row[i + 1] = '|';
                    split_count += 1;
                }
                cur_row[i] = '.';
            }
        }
        debug.print("{s}\n", .{cur_row});
        @memcpy(&above_row, cur_row[0..N_COLS]);
    }
    debug.print("Part 1: {d}\n", .{split_count});
}

const Coord = struct {
    x: usize,
    y: usize,
};

const Node = struct {
    left: ?*Node = null,
    right: ?*Node = null,
};

test "hash stuff" {
    var map = std.AutoHashMap(Coord, Node).init(std.testing.allocator);
    defer map.deinit();

    try map.put(.{ .x = 0, .y = 0 }, .{});
    try expect(map.contains(.{ .x = 0, .y = 0 }) == true);
}
