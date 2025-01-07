const std = @import("std");
const rl = @import("raylib");
const shapes = @import("shapes.zig");
const Config = @import("config.zig").Config;

pub fn updateRectangle(rect: *shapes.Rectangle, wWidth: i32, wHeight: i32) void {
    rect.pos.x += rect.speed.x;
    rect.pos.y += rect.speed.y;

    if (rect.pos.x < 0 or rect.pos.x + rect.width > @as(f32, @floatFromInt(wWidth))) {
        rect.speed.x *= -1; // reverse horizontal direction
    }

    if (rect.pos.y < 0 or rect.pos.y + rect.height > @as(f32, @floatFromInt(wHeight))) {
        rect.speed.y *= -1; // reverse vertical direction
    }
}

pub fn drawRectangle(rect: *shapes.Rectangle) void {
    rl.drawRectangle(
        @intFromFloat(rect.pos.x),
        @intFromFloat(rect.pos.y),
        @intFromFloat(rect.width),
        @intFromFloat(rect.height),
        rect.color,
    );
}

pub fn updateCircle(circle: *shapes.Circle, wWidth: i32, wHeight: i32) void {
    circle.pos.x += circle.speed.x;
    circle.pos.y += circle.speed.y;

    if (circle.pos.x - circle.radius < 0 or circle.pos.x + circle.radius > @as(f32, @floatFromInt(wWidth))) {
        circle.speed.x *= -1; // reverse horizontal direction
    }

    if (circle.pos.y - circle.radius < 0 or circle.pos.y + circle.radius > @as(f32, @floatFromInt(wHeight))) {
        circle.speed.y *= -1; // reverse vertical direction
    }
}

pub fn drawCircle(circle: *shapes.Circle) void {
    rl.drawCircle(
        @intFromFloat(circle.pos.x),
        @intFromFloat(circle.pos.y),
        circle.radius,
        circle.color,
    );
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = Config.init(allocator, "config/config.txt") catch unreachable;
    defer config.deinit(allocator);

    rl.initWindow(config.windowWidth, config.windowHeight, "Zig gaming");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    const font = rl.loadFont(config.font.path);
    defer rl.unloadFont(font);

    while (!rl.windowShouldClose()) {
        const wWidth = rl.getScreenWidth();
        const wHeight = rl.getScreenHeight();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        for (config.rectangles.items) |*rect| {
            updateRectangle(rect, wWidth, wHeight);
            drawRectangle(rect);
        }

        for (config.circles.items) |*circle| {
            updateCircle(circle, wWidth, wHeight);
            drawCircle(circle);
        }
    }
}
