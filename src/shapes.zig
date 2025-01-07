const std = @import("std");
const rl = @import("raylib");

pub const Rectangle = struct {
    name: [*:0]const u8,
    pos: rl.Vector2,
    speed: rl.Vector2,
    color: rl.Color,
    width: f32,
    height: f32,
    shouldDraw: bool,
};

pub const Circle = struct {
    name: [*:0]const u8,
    pos: rl.Vector2,
    speed: rl.Vector2,
    color: rl.Color,
    radius: f32,
    shouldDraw: bool,
};
