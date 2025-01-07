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

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.drawText("Hello, zig!", 200, 200, 20, rl.Color.white);
    }
}
