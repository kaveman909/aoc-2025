const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const math = std.math;
const expect = std.testing.expect;

pub fn run() !void {
    const input = @embedFile("input/day2.txt");
    std.debug.print("Input: {s}\n", .{input});

    var it_range = mem.splitAny(u8, input, ",");
    while (it_range.next()) |range| {
        std.debug.print("{s}, ", .{range});
        var it_vals = mem.splitAny(u8, range, "-");
        const min = fmt.parseInt(u64, it_vals.first(), 10) catch 0;
        const max = fmt.parseInt(u64, it_vals.next().?, 10) catch 0;
        std.debug.print("min: {d}, max: {d}\n", .{ min, max });

        // var ids = min;
        // figure out first value / last value, diff:
        // 442734 -> 443443 -> 443 -> (459 - 443) + 1
        // 459620 -> 459459 -> 459
    }
}

fn getHalves(in: u64, num_digits: u64) struct { u64, u64 } {
    const num_half = num_digits / 2;
    const k = math.powi(u64, 10, num_half) catch 1;
    const upper_half = in / k;
    const lower_half = in - (upper_half * k);
    std.debug.print("upper: {d}, lower: {d}\n", .{ upper_half, lower_half });
    return .{ upper_half, lower_half };
}

fn getMax(in: u64) u64 {
    var in_mut = in;
    var num_digits = getNumDigits(in);
    if ((num_digits % 2) != 0) {
        num_digits -= 1;
        in_mut = (math.powi(u64, 10, num_digits) catch 1) - 1;
    }
    const upper_half, const lower_half = getHalves(in_mut, num_digits);
    if (lower_half >= upper_half) {
        return upper_half;
    }
    return upper_half - 1;
}

fn getMin(in: u64) u64 {
    var in_mut = in;
    var num_digits = getNumDigits(in);
    if ((num_digits % 2) != 0) {
        in_mut = math.powi(u64, 10, num_digits) catch 1;
        num_digits += 1;
    }
    const upper_half, const lower_half = getHalves(in_mut, num_digits);

    if (lower_half > upper_half) {
        return upper_half + 1;
    }
    return upper_half;
}

fn getNumDigits(in: u64) u64 {
    // 18,446,744,073,709,551,615
    const table = [_]u64{ 9, 99, 999, 9999, 99999, 999999, 9999999, 99999999, 999999999, 9999999999, 99999999999, 999999999999, 9999999999999, 99999999999999, 999999999999999, 9999999999999999, 99999999999999999, 999999999999999999 };
    var y: u64 = math.log2_int(@TypeOf(in), in);
    y = (y * 9) >> 5;
    if (in > table[y]) {
        y += 1;
    }
    return y + 1;
}

test "get some digits" {
    try expect(getNumDigits(5) == 1);
    try expect(getNumDigits(123) == 3);
    try expect(getNumDigits(13738) == 5);
    try expect(getNumDigits(363849596857463626) == 18);
}

test "get some mins" {
    try expect(getMin(1234) == 13);
    try expect(getMin(1212) == 12);
    try expect(getMin(463) == 10);
}

test "get some maxes" {
    try expect(getMax(1234) == 12);
    try expect(getMax(1210) == 11);
    try expect(getMax(100) == 9);
}
