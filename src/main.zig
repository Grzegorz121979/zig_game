const std = @import("std");

const User = struct {
    name: []const u8,
    age: u8,
};

pub fn main() !void {
    const user = User {
        .name = "Greg",
        .age = 46,
    };

    std.debug.print("Name: {s}, age: {d}\n", .{user.name, user.age});
}
