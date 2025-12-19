const std = @import("std");
const debug = std.debug;
const mem = std.mem;

const Chosen = struct {
    highest: u8,
    second_highest: u8,
};

const BANK_LEN = 100;

pub fn run() !void {
    const input = @embedFile("input/day3.txt");
    var battery_sum: u32 = 0;
    var battery_sum2: u64 = 0;
    var it_range = mem.splitAny(u8, input, "\n");
    while (it_range.next()) |bank| {
        var chosen: Chosen = .{ .highest = 0, .second_highest = 0 };
        var batteries = mem.reverseIterator(bank);
        const last_battery = batteries.next().? - 48;
        while (batteries.next()) |battery_c| {
            const battery = battery_c - 48;
            if (battery >= chosen.highest) {
                chosen.second_highest = chosen.highest;
                chosen.highest = battery;
            }
        }
        chosen.second_highest = @max(chosen.second_highest, last_battery);
        const chosen_sum: u32 = chosen.highest * 10 + chosen.second_highest;
        battery_sum += chosen_sum;
        // part 2
        var start_i: usize = 0;
        var iter: u32 = 12;
        var chosen_sum2: u64 = 0;
        while (iter > 0) {
            var highest: u32 = 0;
            var next_start: usize = 0;
            for (bank[start_i .. BANK_LEN - iter + 1], start_i..) |battery_c, i| {
                const battery = battery_c - 48;
                if (battery > highest) {
                    highest = battery;
                    next_start = i + 1;
                }
            }
            start_i = next_start;
            iter -= 1;
            chosen_sum2 = (chosen_sum2 * 10) + highest;
        }
        battery_sum2 += chosen_sum2;
    }
    debug.print("Part 1: {}\n", .{battery_sum});
    debug.print("Part 2: {}\n", .{battery_sum2});
}
