const std = @import("std");
const debug = std.debug;
const mem = std.mem;

const Chosen = struct {
    highest: u8,
    second_highest: u8,
};

pub fn run() !void {
    const input = @embedFile("input/day3.txt");
    var battery_sum: u32 = 0;
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
    }
    debug.print("Part 1: {}\n", .{battery_sum});
}
