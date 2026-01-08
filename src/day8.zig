const std = @import("std");
const math = std.math;
const mem = std.mem;
const fmt = std.fmt;
const debug = std.debug;
const heap = std.heap;
const array_list = std.array_list;

pub fn run() !void {
    const input = @embedFile("input/day8_sample.txt");
    var boxes_in = mem.splitAny(u8, input, "\n");

    const N_BOXES: usize = 20;
    var boxes: [N_BOXES]Box = undefined;
    var i: usize = 0;
    while (boxes_in.next()) |box_in| : (i += 1) {
        var box_coords = mem.splitAny(u8, box_in, ",");
        var box: [3]i64 = undefined;
        var j: usize = 0;
        while (box_coords.next()) |box_coord| : (j += 1) {
            box[j] = try fmt.parseInt(i64, box_coord, 10);
        }
        boxes[i].coord = .{ .x = box[0], .y = box[1], .z = box[2] };
        boxes[i].circuit = i;
    }
    //debug.print("{any}\n", .{boxes});

    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var box_pairs = std.array_list.Managed(BoxPair).init(allocator);
    defer box_pairs.deinit();

    const BoxList = std.array_list.Managed(&Box);

    // calculate all distances between boxes
    for (0..N_BOXES) |ii| {
        for ((ii + 1)..N_BOXES) |j| {
            const box1 = &boxes[ii];
            const box2 = &boxes[j];
            const dist = try distance(box1.coord, box2.coord);
            try box_pairs.append(.{ .b1 = box1, .b2 = box2, .d = dist });
            //debug.print("{d}\n", .{dist});
        }
        //debug.print("\n", .{});
    }

    // sort the distances
    mem.sort(BoxPair, box_pairs.items, {}, compareBoxPair);
    var circuit_map = std.AutoHashMap(usize, BoxList).init(allocator);

    for (0..10) |ii| {
        var b1 = box_pairs.items[ii].b1;
        var b2 = box_pairs.items[ii].b2;
        if (b2.circuit != b1.circuit) {
            // TODO
            // check if one of the circuits is already in the circuit map
            // if so, consume the other circuit (don't think it matters which one?)
            // (make sure to delete the other circuit from map)
            // (and append the new Boxes to the 'surviving' circuit map)
            // update box circuit values as well so things stay in sync.
        } // else, nothing happens
        //debug.print("{any}\n", .{box_pairs.items[ii]});
    }
    for (boxes) |box| {
        debug.print("{any}\n", .{box});
    }
}

const Coord = struct {
    x: i64,
    y: i64,
    z: i64,
};

const Box = struct {
    coord: Coord,
    circuit: usize,
};

const BoxPair = struct {
    b1: *Box,
    b2: *Box,
    d: i64,
};

fn distance(c0: Coord, c1: Coord) !i64 {
    const x = try math.powi(i64, (c0.x - c1.x), 2);
    const y = try math.powi(i64, (c0.y - c1.y), 2);
    const z = try math.powi(i64, (c0.z - c1.z), 2);

    return x + y + z;
}

fn compareBoxPair(context: void, p1: BoxPair, p2: BoxPair) bool {
    _ = context;
    return p1.d < p2.d;
}
