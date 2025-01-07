const std = @import("std");
const rl = @import("raylib");

const WIDTH = 800;
const HEIGHT = 600;

pub const Game = struct {
    const Self = @This();
};

pub fn frame() !void {}

pub fn main() !void {
    rl.setConfigFlags(rl.ConfigFlags{
        .window_resizable = false,
    });
    rl.initWindow(WIDTH, HEIGHT, "Zig gaming");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    const font = rl.loadFont("fonts/BigBlue_TerminalPlus.ttf");
    defer rl.unloadFont(font);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        const screenWidth = rl.getScreenWidth();
        const screenHeight = rl.getScreenHeight();
        const text = "Hello, World!";
        const textSize = rl.measureTextEx(font, text, 20.0, 2.0);
        const middle = rl.Vector2{
            .x = @as(f32, @floatFromInt(@divTrunc(screenWidth, 2))) - (textSize.x / 2.0),
            .y = @as(f32, @floatFromInt(@divTrunc(screenHeight, 2))) - (textSize.y / 2.0),
        };

        rl.clearBackground(rl.Color.black);
        rl.drawTextEx(font, text, middle, 20.0, 2.0, rl.Color.white);
    }
}
