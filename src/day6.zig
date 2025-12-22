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
}
