const std = @import("std");
const aoc_2025 = @import("aoc_2025");
const fmt = std.fmt;
const fs = std.fs;
const mem = std.mem;

pub fn main() !void {
    try day1();
}

pub fn day1() !void {
    const input = @embedFile("input/day1.txt");
    var zero_count: u32 = 0;
    var pos: u32 = 50;
    var it = mem.splitAny(u8, input, "\n");
    const move = it.first();

    pos = try processMove(move, pos);
    if (pos == 0) {
        zero_count += 1;
    }
    while (it.next()) |move2| {
        pos = try processMove(move2, pos);
        if (pos == 0) {
            zero_count += 1;
        }
    }
    std.debug.print("Part 1: {}\n", .{zero_count});
}

const ProcessMoveError = error{InvalidMove};

fn processMove(move: []const u8, pos: u32) !u32 {
    const dir = move[0];
    const len = fmt.parseInt(u32, move[1..], 10) catch 0;

    if (dir == 'R') {
        return (pos + len) % 100;
    } else if (dir == 'L') {
        const len_capped = len % 100;
        if (len_capped > pos) {
            return 100 - (len_capped - pos);
        }
        return pos - len_capped;
    }
    return error.InvalidMove;
}
