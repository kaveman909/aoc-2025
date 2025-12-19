const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const math = std.math;
const expect = std.testing.expect;

pub fn run() !void {
    const input = @embedFile("input/day2.txt");

    var it_range = mem.splitAny(u8, input, ",");
    var total_invalid: u64 = 0;
    var total_invalid2: u64 = 0;
    while (it_range.next()) |range| {
        var it_vals = mem.splitAny(u8, range, "-");
        const min_in = try fmt.parseInt(u64, it_vals.first(), 10);
        const max_in = try fmt.parseInt(u64, it_vals.next().?, 10);
        const min = getMin(min_in);
        const max = getMax(max_in);
        if (min <= max) {
            var local_total: u64 = 0;
            for (min..(max + 1)) |i| {
                local_total += i;
                local_total += (math.powi(u64, 10, getNumDigits(i)) catch 1) * i;
            }
            total_invalid += local_total;
        }
        for (min_in..(max_in + 1)) |i| {
            if (try isInvalid(i)) {
                total_invalid2 += i;
            }
        }
    }
    std.debug.print("Part 1: {d}\n", .{total_invalid});
    std.debug.print("Part 2: {d}\n", .{total_invalid2});
}

fn getHalves(in: u64, num_digits: u64) struct { u64, u64 } {
    const num_half = num_digits / 2;
    const k = math.powi(u64, 10, num_half) catch 1;
    const upper_half = in / k;
    const lower_half = in - (upper_half * k);
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

fn isInvalid2(in: []u8, N: usize, factors: []const u32) bool {
    for (factors) |chunk_size| {
        const num_chunks = N / chunk_size;
        const first_chunk = in[0..chunk_size];
        var invalid = true;
        for (1..num_chunks) |i| {
            const new_chunk = in[i * chunk_size .. (i * chunk_size) + chunk_size];
            if (!mem.eql(u8, new_chunk, first_chunk)) {
                invalid = false;
                break;
            }
        }
        if (invalid) {
            return true;
        }
    }
    return false;
}

fn isInvalid(in: u64) !bool {
    const factors_list = [_][]const u32{
        &[_]u32{1}, //2
        &[_]u32{1}, //3
        &[_]u32{ 1, 2 }, //4
        &[_]u32{1}, //5
        &[_]u32{ 1, 2, 3 }, //6
        &[_]u32{1}, //7
        &[_]u32{ 1, 2, 4 }, //8
        &[_]u32{ 1, 3 }, //9
        &[_]u32{ 1, 2, 5 }, //10
    };

    var buf: [20]u8 = undefined;
    const in_str = try fmt.bufPrint(&buf, "{}", .{in});
    const N = in_str.len;
    if (N < 2) {
        return false;
    }
    const factors = factors_list[N - 2];

    return isInvalid2(in_str, N, factors);
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

test "print chunks" {
    try expect((try isInvalid(1111)) == true);
    try expect((try isInvalid(1111)) == true);
    try expect((try isInvalid(22222222)) == true); // 1
    try expect((try isInvalid(12121212)) == true); // 2
    try expect((try isInvalid(23452345)) == true); // 4
    try expect((try isInvalid(135135135)) == true); // 3
    try expect((try isInvalid(135135136)) == false); // 3
    try expect((try isInvalid(1234512345)) == true); // 5
    try expect((try isInvalid(12131212)) == false);
    try expect((try isInvalid(12121312)) == false);
}
