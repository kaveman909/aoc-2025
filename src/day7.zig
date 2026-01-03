const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const testing = std.testing;
const heap = std.heap;
const expect = std.testing.expect;

pub fn run() !void {
    const input = @embedFile("input/day7_sample.txt");
    const N_COLS = 15;

    var grid_in = mem.splitAny(u8, input, "\n");
    var cur_row: [N_COLS]u8 = undefined;
    var above_row: [N_COLS]u8 = undefined;
    var split_count: u64 = 0;
    @memcpy(&above_row, grid_in.first()[0..N_COLS]);

    // grid / j only used for Part 2, but populate during Part 1 for efficiency
    var grid: [N_COLS][N_COLS]u8 = undefined;
    var j: usize = 0;
    while (grid_in.next()) |row| : (j += 1) {
        for (row, 0..) |cell, i| {
            grid[j][i] = cell;
            if (cell == '.') {
                if (cur_row[i] == '|' or above_row[i] == '|' or above_row[i] == 'S') {
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
        @memcpy(&above_row, cur_row[0..N_COLS]);
    }
    debug.print("Part 1: {d}\n", .{split_count});

    // part 2
    // Following recommendation at https://ziglang.org/documentation/0.15.2/#Choosing-an-Allocator
    // to use the "arena" allocator for a cmd line app that runs start-to-finish in a known fasion,
    // allocating memory at beginnging and releasing at end of program.

    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var tree = std.AutoHashMap(Coord, Node).init(allocator);
    for (0..N_COLS) |y| {
        for (0..N_COLS) |x| {
            if (grid[y][x] != '^') {
                continue;
            }
            // find left/right nodes
            var left: ?Coord = null;
            var right: ?Coord = null;
            for ((y + 1)..N_COLS) |y2| {
                if (grid[y2][x - 1] == '^') {
                    if (left == null) {
                        left = .{ .x = x - 1, .y = y2 };
                    }
                }
                if (grid[y2][x + 1] == '^') {
                    if (right == null) {
                        right = .{ .x = x + 1, .y = y2 };
                    }
                }
                if (right != null and left != null) {
                    break;
                }
            }
            try tree.put(.{ .x = x, .y = y }, .{ .left = left, .right = right });
        }
    }

    const total_paths = traverse(.{ .x = N_COLS / 2, .y = 1 }, tree);
    debug.print("Part 2: {}\n", .{total_paths});
}

const Coord = struct {
    x: usize,
    y: usize,
};

const Node = struct {
    left: ?Coord = null,
    right: ?Coord = null,
};

test "hash stuff" {
    var map = std.AutoHashMap(Coord, Node).init(std.testing.allocator);
    defer map.deinit();

    try map.put(.{ .x = 0, .y = 0 }, .{});
    try expect(map.contains(.{ .x = 0, .y = 0 }) == true);
}

fn traverse(node: Coord, tree: std.AutoHashMap(Coord, Node)) u32 {
    var total: u32 = 0;
    const left = tree.get(node).?.left;
    if (left != null) {
        total += traverse(left.?, tree);
    } else {
        total += 1;
    }
    const right = tree.get(node).?.right;
    if (right != null) {
        total += traverse(right.?, tree);
    } else {
        total += 1;
    }
    return total;
}
