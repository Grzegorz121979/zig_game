const std = @import("std");

const User = struct {
    name: []const u8,
    age: u8,
};

pub fn main() !void {

    var stdin_buffer: [16]u8 = undefined;
    var stdout_buffer: [16]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdin = &stdin_reader.interface;
    const stdout = &stdout_writer.interface;

    stdout.writeAll("Hello, world!");
    _ = stdin;

    const user = User {
        .name = "Greg",
        .age = 46,
    };

    std.debug.print("Name: {s}, age: {d}\n", .{user.name, user.age});
}
