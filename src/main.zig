const std = @import("std");

const User = struct {
    name: []const u8,
    age: u8,
};

fn getUserData() !User {
    var stdin_name: [16]u8 = undefined;
    var stdin_name_reader = std.fs.File.stdin().reader(&stdin_name);
    const stdin_name_interface = &stdin_name_reader.interface;

    var stdin_age: [16]u8 = undefined;
    var stdin_age_reader = std.fs.File.stdin().reader(&stdin_age);
    var stdin_age_interface = &stdin_age_reader.interface;

    var stdout_buffer: [16]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("What's your name: ");
    const name = try stdin_name_interface.takeDelimiterExclusive('\n');
    const trimmed_name = std.mem.trim(u8, name, " \n\r\t");

    try stdout.writeAll("How old are you: ");
    const age = try stdin_age_interface.takeDelimiterExclusive('\n');
    const trimmed_age = std.mem.trim(u8, age, " \n\r\t");
    const parse_age = try std.fmt.parseInt(u8, trimmed_age, 10);

    return User {
        .name = trimmed_name,
        .age = parse_age,
    };
}

pub fn main() !void {
    const user = try getUserData();
    std.debug.print("Name: {s}, age: {d}\n", .{user.name, user.age});
}
