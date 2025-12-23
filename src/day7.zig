const std = @import("std");
const mem = std.mem;
const debug = std.debug;

pub fn run() !void {
    const input = @embedFile("input/day7.txt");
    const N_ROWS = 142;
    const N_COLS = 141;

    var grid: [N_ROWS][N_COLS]u8 = undefined;

    var grid_in = mem.splitAny(u8, input, "\n");
    var j: usize = 0;
    while (grid_in.next()) |row| : (j += 1) {
        for (row, 0..) |cell, i| {
            grid[j][i] = cell;
        }
        debug.print("{s}\n", .{grid[j]});
    }
}
