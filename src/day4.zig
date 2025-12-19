const std = @import("std");
const debug = std.debug;
const mem = std.mem;

const N_X = 136;
const N_Y = 136;

pub fn run() !void {
    const input = @embedFile("input/day4.txt");
    var map: [N_Y][N_X]u8 = undefined;

    var map_in = mem.splitAny(u8, input, "\n");
    var y1: usize = 0;
    while (map_in.next()) |row| : (y1 += 1) {
        for (row, 0..) |cell, x| {
            map[y1][x] = cell;
        }
    }
    var total_accessible_rolls: u32 = 0;
    for (0..N_Y) |y| {
        for (0..N_X) |x| {
            if (map[y][x] == '@') {
                if (countNearbyRolls(map, y, x) < 4) {
                    total_accessible_rolls += 1;
                }
            }
        }
    }
    debug.print("Part 1: {}\n", .{total_accessible_rolls});
    // part 2
    var removed_rolls: u32 = 0;
    var removed_at_least_one: bool = true;
    while (removed_at_least_one) {
        removed_at_least_one = false;
        for (0..N_Y) |y| {
            for (0..N_X) |x| {
                if (map[y][x] == '@') {
                    if (countNearbyRolls(map, y, x) < 4) {
                        removed_rolls += 1;
                        removed_at_least_one = true;
                        map[y][x] = '.';
                    }
                }
            }
        }
    }
    debug.print("Part 2: {}\n", .{removed_rolls});
}

fn countNearbyRolls(map: [N_Y][N_X]u8, y: usize, x: usize) u32 {
    const y_start = if (y > 0) y - 1 else y;
    const x_start = if (x > 0) x - 1 else x;
    const y_end = if (y < N_Y - 1) y + 1 else y;
    const x_end = if (x < N_X - 1) x + 1 else x;

    var roll_count: u32 = 0;

    for (y_start..y_end + 1) |y1| {
        for (x_start..x_end + 1) |x1| {
            if ((y1 == y) and (x1 == x)) {
                continue;
            }
            if (map[y1][x1] == '@') {
                roll_count += 1;
            }
        }
    }

    return roll_count;
}
