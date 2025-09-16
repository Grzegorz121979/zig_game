const std = @import("std");

const User = struct {
    name: []const u8,
    age: u8,
};

fn getUserData(alloc: std.mem.Allocator) !User {
    var stdin_buffer: [32]u8 = undefined;
    var age_buffer: [32]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;

    std.debug.print("What's your name?:\n", .{});
    const name = try stdin.takeDelimiterExclusive('\n');
    const name_alloc = try alloc.dupe(u8, std.mem.trim(u8, name, " \r\n\t"));

    std.debug.print("How old are you?:\n", .{});
    var age_reader = std.fs.File.stdin().reader(&age_buffer);
    var stdin2 = &age_reader.interface;
    const age = try stdin2.takeDelimiterExclusive('\n');
    const trimmed_age = std.mem.trim(u8, age, " \n\r\t");
    const parse_age = try std.fmt.parseInt(u8, trimmed_age, 10);

    return User {
        .name = name_alloc,
        .age = parse_age,
    };
}

fn writeToJsonFile(path_file: []const u8, alloc: std.mem.Allocator, user: User) !void {
    var list = std.array_list.Managed(User).init(alloc);
    defer list.deinit();
    try list.append(user);
    const file = try std.fs.cwd().createFile(path_file, .{});
    defer file.close();
    const content = try std.json.Stringify.valueAlloc(alloc, list.items, .{.whitespace = .indent_4});
    defer alloc.free(content);
    try file.writeAll(content);
}

pub fn main() !void {
    const file_path = "user.json";
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const user_data = try getUserData(alloc);
    
    try writeToJsonFile(file_path, alloc, user_data);
    defer alloc.free(user_data.name);
    std.debug.print("Name: {s}, age: {d}\n", .{user_data.name, user_data.age});
}
