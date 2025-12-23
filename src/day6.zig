const std = @import("std");
const mem = std.mem;
const debug = std.debug;
const fmt = std.fmt;
const BoundedArray = @import("bounded_array").BoundedArray;

pub fn run() !void {
    const input = @embedFile("input/day6.txt");

    const N_NUMBER_ROWS = 4;
    const N_TOTAL_ROWS = 1000;
    var numbers = [_]BoundedArray(u64, N_TOTAL_ROWS){
        BoundedArray(u64, N_TOTAL_ROWS){},
    } ** N_NUMBER_ROWS;
    var operators = BoundedArray(u8, N_TOTAL_ROWS){};

    var math_problems_in = mem.splitAny(u8, input, "\n");

    var i: usize = 0;
    while (math_problems_in.next()) |row_in| : (i += 1) {
        var cols_in = mem.splitAny(u8, row_in, " ");
        while (cols_in.next()) |col_in| {
            if (col_in.len == 0) {
                continue;
            }
            if (i < 4) {
                const num = try fmt.parseInt(u64, col_in, 10);
                try numbers[i].append(num);
            } else {
                try operators.append(col_in[0]);
            }
        }
    }
    var total_sum: u64 = 0;
    for (operators.buffer, 0..) |operator, idx| {
        if (operator == '*') {
            total_sum += (numbers[0].get(idx) * numbers[1].get(idx) * numbers[2].get(idx) * numbers[3].get(idx));
        } else {
            total_sum += (numbers[0].get(idx) + numbers[1].get(idx) + numbers[2].get(idx) + numbers[3].get(idx));
        }
    }
    debug.print("Part 1: {d}\n", .{total_sum});
    // part 2
    math_problems_in.reset();
    _ = math_problems_in.first();
    const width = math_problems_in.index.?;
    const buf = math_problems_in.buffer;

    var cur_op: u8 = undefined;
    var cur_total: u64 = undefined;
    var grand_total: u64 = 0;

    for (buf[0 .. width - 1], buf[width .. 2 * width - 1], buf[2 * width .. 3 * width - 1], buf[3 * width .. 4 * width - 1], buf[4 * width .. 5 * width - 1]) |c1, c2, c3, c4, op| {
        const d: [4]u8 = .{ c1, c2, c3, c4 };
        const d_trim = mem.trim(u8, &d, " ");
        if (d_trim.len > 0) {
            if (op != ' ') {
                // start of new math problem
                cur_op = op;
                if (cur_op == '*') {
                    cur_total = 1;
                } else {
                    cur_total = 0;
                }
            }
            const d_int = try fmt.parseInt(u64, d_trim, 10);
            if (cur_op == '*') {
                cur_total *= d_int;
            } else {
                cur_total += d_int;
            }
        } else {
            // end of math problem
            grand_total += cur_total;
        }
    }
    grand_total += cur_total;
    debug.print("Part 2: {d}\n", .{grand_total});
}
