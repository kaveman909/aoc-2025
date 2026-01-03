const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const debug = std.debug;

pub fn run() !void {
    const input = @embedFile("input/day8_sample.txt");
    var boxes_in = mem.splitAny(u8, input, "\n");

    const N_BOXES: usize = 20;
    var boxes: [N_BOXES]Coord = undefined;
    var i: usize = 0;
    while (boxes_in.next()) |box_in| : (i += 1) {
        var box_coords = mem.splitAny(u8, box_in, ",");
        var box: [3]u32 = undefined;
        var j: usize = 0;
        while (box_coords.next()) |box_coord| : (j += 1) {
            box[j] = try fmt.parseInt(u32, box_coord, 10);
        }
        boxes[i] = .{ .x = box[0], .y = box[1], .z = box[2] };
    }
    debug.print("{any}\n", .{boxes});
}

const Coord = struct {
    x: u32,
    y: u32,
    z: u32,
};
