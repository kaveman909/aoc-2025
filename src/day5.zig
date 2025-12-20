const std = @import("std");
const debug = std.debug;
const mem = std.mem;
const fmt = std.fmt;
const math = std.math;
const BoundedArray = @import("bounded_array").BoundedArray;

const Range = struct {
    start: u64,
    end: u64,
};

pub fn run() !void {
    const input1 = @embedFile("input/day5.1.txt");
    const input2 = @embedFile("input/day5.2.txt");

    const NUM_RANGES = 182;

    var fresh_ranges_in = mem.splitAny(u8, input1, "\n");
    var available_ids_in = mem.splitAny(u8, input2, "\n");

    var fresh_ranges: [NUM_RANGES]Range = undefined;

    var i: usize = 0;
    while (fresh_ranges_in.next()) |fresh_range| : (i += 1) {
        var start_end = mem.splitAny(u8, fresh_range, "-");
        const start = try fmt.parseInt(u64, start_end.first(), 10);
        const end = try fmt.parseInt(u64, start_end.next().?, 10);
        fresh_ranges[i] = .{ .start = start, .end = end };
    }

    // sort + merge ranges
    mem.sort(Range, &fresh_ranges, {}, compareByStart);
    var merged_ranges = BoundedArray(Range, NUM_RANGES){};
    try merged_ranges.append(fresh_ranges[0]);
    for (fresh_ranges[1..]) |range| {
        var last_merged = &merged_ranges.slice()[merged_ranges.len - 1];
        if (range.start > (last_merged.end + 1)) {
            // new range
            try merged_ranges.append(range);
        } else {
            // merge ranges
            last_merged.end = @max(range.end, last_merged.end);
        }
    }

    var fresh_total: u32 = 0;
    while (available_ids_in.next()) |id_str| : (i += 1) {
        const id = try fmt.parseInt(u64, id_str, 10);
        // find first start past the id
        const idx = std.sort.lowerBound(Range, merged_ranges.slice(), id, compareByStartOrder);
        if (idx == 0) {
            continue;
        }
        const r = merged_ranges.get(idx - 1);
        if (id <= r.end) {
            fresh_total += 1;
        }
    }
    debug.print("Part 1: {}\n", .{fresh_total});
}

fn compareByStartOrder(id: u64, r: Range) math.Order {
    if (id > r.start) {
        return math.Order.gt;
    }
    if (id < r.start) {
        return math.Order.lt;
    }
    return math.Order.eq;
}

fn compareByStart(context: void, a: Range, b: Range) bool {
    _ = context;
    return a.start < b.start;
}
