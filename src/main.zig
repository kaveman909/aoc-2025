const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub fn main() !void {
    try day1();
}

pub fn day1() !void {
    const input = @embedFile("input/day1.txt");
    var zero_count: u32 = 0;
    var turns: u32 = 0;
    var zero_count2: u32 = 0;
    var pos: u32 = 50;
    var it = mem.splitAny(u8, input, "\n");

    while (it.next()) |move| {
        pos, turns = try processMove(move, pos);
        if (pos == 0) {
            zero_count += 1;
        }
        zero_count2 += turns;
    }
    std.debug.print("Part 1: {}\n", .{zero_count});
    std.debug.print("Part 2: {}\n", .{zero_count2});
}

const ProcessMoveError = error{InvalidMove};

fn processMove(move: []const u8, pos: u32) !struct { u32, u32 } {
    const dir = move[0];
    const len = fmt.parseInt(u32, move[1..], 10) catch 0;

    if (dir == 'R') {
        const turns = (pos + len) / 100;
        return .{ (pos + len) % 100, turns };
    } else if (dir == 'L') {
        const mirror_pos = (100 - pos) % 100;
        const turns = (mirror_pos + len) / 100;
        return .{ (100 - ((mirror_pos + len) % 100)) % 100, turns };
    }
    return error.InvalidMove;
}
