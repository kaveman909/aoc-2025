const std = @import("std");
const debug = std.debug;
const mem = std.mem;
const fmt = std.fmt;
const BoundedArray = @import("bounded_array").BoundedArray;

const Range = struct {
    start: u64,
    end: u64,
};

fn compareByStart(context: void, a: Range, b: Range) bool {
    _ = context;
    return a.start < b.start;
}

pub fn run() !void {
    const input1 = @embedFile("input/day5.1.txt");
    const input2 = @embedFile("input/day5.2.txt");

    const NUM_IDS = 1000;
    const NUM_RANGES = 182;

    var fresh_ranges_in = mem.splitAny(u8, input1, "\n");
    var available_ids_in = mem.splitAny(u8, input2, "\n");

    var available_ids: [NUM_IDS]u64 = undefined;
    var fresh_ranges: [NUM_RANGES]Range = undefined;

    var i: usize = 0;
    while (available_ids_in.next()) |id| : (i += 1) {
        available_ids[i] = try fmt.parseInt(u64, id, 10);
    }

    i = 0;
    while (fresh_ranges_in.next()) |fresh_range| : (i += 1) {
        var start_end = mem.splitAny(u8, fresh_range, "-");
        const start = try fmt.parseInt(u64, start_end.first(), 10);
        const end = try fmt.parseInt(u64, start_end.next().?, 10);
        fresh_ranges[i] = .{ .start = start, .end = end };
    }

    // sort ranges
    mem.sort(Range, &fresh_ranges, {}, compareByStart);
    for (fresh_ranges) |r| {
        debug.print("{any}\n", .{r});
    }

    // merge ranges
    var merged_ranges = BoundedArray(Range, NUM_RANGES){};
    try merged_ranges.append(fresh_ranges[0]);
    debug.print("{any}, {d}\n", .{ merged_ranges.get(0), merged_ranges.len });
}
