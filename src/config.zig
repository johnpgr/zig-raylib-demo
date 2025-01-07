const std = @import("std");
const rl = @import("raylib");
const shapes = @import("shapes.zig");

pub const Config = struct {
    windowWidth: i32,
    windowHeight: i32,
    font: struct {
        path: [*:0]const u8,
        size: i32,
        color: rl.Color,
    },
    rectangles: std.ArrayList(shapes.Rectangle),
    circles: std.ArrayList(shapes.Circle),

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, configFilePath: []const u8) !Config {
        const file = try std.fs.cwd().openFile(configFilePath, .{});
        std.debug.print("INFO: Reading config file: {s}\n", .{configFilePath});
        defer file.close();

        var config = Config{
            .windowWidth = 0,
            .windowHeight = 0,
            .font = .{
                .path = undefined,
                .size = 0,
                .color = undefined,
            },
            .rectangles = std.ArrayList(shapes.Rectangle).init(allocator),
            .circles = std.ArrayList(shapes.Circle).init(allocator),
        };

        var bufReader = std.io.bufferedReader(file.reader());
        var inStream = bufReader.reader();
        var buf: [1024]u8 = undefined;

        while (try inStream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var tokens = std.mem.tokenize(u8, line, " ");
            const cmd = tokens.next() orelse continue;

            if (std.mem.eql(u8, cmd, "Window")) {
                config.windowWidth = try std.fmt.parseInt(i32, tokens.next().?, 10);
                config.windowHeight = try std.fmt.parseInt(i32, tokens.next().?, 10);
            }
            if (std.mem.eql(u8, cmd, "Font")) {
                const path = tokens.next().?;
                config.font.path = try allocator.dupeZ(u8, path);
                config.font.size = try std.fmt.parseInt(i32, tokens.next().?, 10);
                const r = try std.fmt.parseInt(u8, tokens.next().?, 10);
                const g = try std.fmt.parseInt(u8, tokens.next().?, 10);
                const b = try std.fmt.parseInt(u8, tokens.next().?, 10);
                config.font.color = rl.Color{
                    .r = r,
                    .g = g,
                    .b = b,
                    .a = 255,
                };
            }
            if (std.mem.eql(u8, cmd, "Rectangle")) {
                const rect = shapes.Rectangle{
                    .name = try allocator.dupe(u8, tokens.next().?),
                    .pos = rl.Vector2{
                        .x = try std.fmt.parseFloat(f32, tokens.next().?),
                        .y = try std.fmt.parseFloat(f32, tokens.next().?),
                    },
                    .speed = rl.Vector2{
                        .x = try std.fmt.parseFloat(f32, tokens.next().?),
                        .y = try std.fmt.parseFloat(f32, tokens.next().?),
                    },
                    .color = rl.Color{ .r = try std.fmt.parseInt(u8, tokens.next().?, 10), .g = try std.fmt.parseInt(u8, tokens.next().?, 10), .b = try std.fmt.parseInt(u8, tokens.next().?, 10), .a = 255 },
                    .width = @floatFromInt(try std.fmt.parseInt(i32, tokens.next().?, 10)),
                    .height = @floatFromInt(try std.fmt.parseInt(i32, tokens.next().?, 10)),
                };
                try config.rectangles.append(rect);
            }
            if (std.mem.eql(u8, cmd, "Circle")) {
                const circle = shapes.Circle{
                    .name = try allocator.dupe(u8, tokens.next().?),
                    .pos = rl.Vector2{
                        .x = try std.fmt.parseFloat(f32, tokens.next().?),
                        .y = try std.fmt.parseFloat(f32, tokens.next().?),
                    },
                    .speed = rl.Vector2{
                        .x = try std.fmt.parseFloat(f32, tokens.next().?),
                        .y = try std.fmt.parseFloat(f32, tokens.next().?),
                    },
                    .color = rl.Color{
                        .r = try std.fmt.parseInt(u8, tokens.next().?, 10),
                        .g = try std.fmt.parseInt(u8, tokens.next().?, 10),
                        .b = try std.fmt.parseInt(u8, tokens.next().?, 10),
                        .a = 255,
                    },
                    .radius = @floatFromInt(try std.fmt.parseInt(i32, tokens.next().?, 10)),
                };
                try config.circles.append(circle);
            }
        }
        std.debug.print("INFO: Configuration file parsed successfully\n", .{});
        return config;
    }
    
    pub fn deinit(self: *const Self, allocator: std.mem.Allocator) void {
        allocator.free(std.mem.span(self.font.path));
        self.rectangles.deinit();
        self.circles.deinit();
    }
};
