const std = @import("std");
const rl = @import("raylib");
const rg = @import("raygui");
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

pub fn drawRectangle(rect: *shapes.Rectangle, font: rl.Font, fontSize: i32) void {
    if (!rect.shouldDraw) {
        return;
    }

    rl.drawRectangle(
        @intFromFloat(rect.pos.x),
        @intFromFloat(rect.pos.y),
        @intFromFloat(rect.width),
        @intFromFloat(rect.height),
        rect.color,
    );

    const textSize = rl.measureTextEx(font, @ptrCast(rect.name), @floatFromInt(fontSize), 0.0);
    const textPos = rl.Vector2{
        .x = rect.pos.x + (rect.width - textSize.x) / 2,
        .y = rect.pos.y + (rect.height - textSize.y) / 2,
    };

    rl.drawTextEx(
        font,
        rect.name,
        textPos,
        @floatFromInt(fontSize),
        0.0,
        rl.Color.white,
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

pub fn drawCircle(circle: *shapes.Circle, font: rl.Font, fontSize: i32) void {
    if (!circle.shouldDraw) {
        return;
    }

    rl.drawCircle(
        @intFromFloat(circle.pos.x),
        @intFromFloat(circle.pos.y),
        circle.radius,
        circle.color,
    );

    const textSize = rl.measureTextEx(font, @ptrCast(circle.name), @floatFromInt(fontSize), 0.0);
    const textPos = rl.Vector2{
        .x = circle.pos.x - textSize.x / 2,
        .y = circle.pos.y - textSize.y / 2,
    };

    rl.drawTextEx(
        font,
        circle.name,
        textPos,
        @floatFromInt(fontSize),
        0.0,
        rl.Color.white,
    );
}

const SelectedShape = union(enum) {
    rectangle: *shapes.Rectangle,
    circle: *shapes.Circle,
};

fn isPointInRectangle(point: rl.Vector2, rect: *shapes.Rectangle) bool {
    return point.x >= rect.pos.x and
        point.x <= rect.pos.x + rect.width and
        point.y >= rect.pos.y and
        point.y <= rect.pos.y + rect.height;
}

fn isPointInCircle(point: rl.Vector2, circle: *shapes.Circle) bool {
    const dx = point.x - circle.pos.x;
    const dy = point.y - circle.pos.y;
    return (dx * dx + dy * dy) <= (circle.radius * circle.radius);
}

// Modify the drawShapeControls function to handle a single shape

pub fn drawShapeControls(selected: SelectedShape) void {
    const panelRect = rl.Rectangle{
        .x = @as(f32, @floatFromInt(rl.getScreenWidth())) - 200,
        .y = 10,
        .width = 200,
        .height = 400,
    };

    switch (selected) {
        .rectangle => |rect| {
            _ = rg.guiPanel(panelRect, "Rectangle Controls");
            var yOffset: f32 = panelRect.y + 30;
            const spacing: f32 = 30;

            // Name display
            _ = rg.guiLabel(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 170, .height = 20 },
                rect.name,
            );
            yOffset += spacing;

            // Position controls
            var posX = rect.pos.x;
            var posY = rect.pos.y;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "X Position",
                "",
                &posX,
                0,
                @as(f32, @floatFromInt(rl.getScreenWidth())),
            )) {
                rect.pos.x = posX;
            }
            yOffset += spacing;

            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Y Position",
                "",
                &posY,
                0,
                @as(f32, @floatFromInt(rl.getScreenHeight())),
            )) {
                rect.pos.y = posY;
            }
            yOffset += spacing;

            // Speed controls
            var speedX = rect.speed.x;
            var speedY = rect.speed.y;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "X Speed",
                "",
                &speedX,
                -5.0,
                5.0,
            )) {
                rect.speed.x = speedX;
            }
            yOffset += spacing;

            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Y Speed",
                "",
                &speedY,
                -5.0,
                5.0,
            )) {
                rect.speed.y = speedY;
            }
            yOffset += spacing;

            // Size controls
            var width = rect.width;
            var height = rect.height;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Width",
                "",
                &width,
                10,
                200,
            )) {
                rect.width = width;
            }
            yOffset += spacing;

            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Height",
                "",
                &height,
                10,
                200,
            )) {
                rect.height = height;
            }
            yOffset += spacing;

            // Color controls
            var color = rect.color;
            if (1 == rg.guiColorPicker(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 150 },
                "Color",
                &color,
            )) {
                rect.color = color;
            }
            yOffset += 160;

            // Visibility toggle
            var visible = rect.shouldDraw;
            if (1 == rg.guiCheckBox(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 20, .height = 20 },
                "Visible",
                &visible,
            )) {
                rect.shouldDraw = visible;
            }
        },
        .circle => |circle| {
            _ = rg.guiPanel(panelRect, "Circle Controls");
            var yOffset: f32 = panelRect.y + 30;
            const spacing: f32 = 30;

            // Name display
            _ = rg.guiLabel(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 170, .height = 20 },
                circle.name,
            );
            yOffset += spacing;

            // Position controls
            var posX = circle.pos.x;
            var posY = circle.pos.y;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "X Position",
                "",
                &posX,
                0,
                @as(f32, @floatFromInt(rl.getScreenWidth())),
            )) {
                circle.pos.x = posX;
            }
            yOffset += spacing;

            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Y Position",
                "",
                &posY,
                0,
                @as(f32, @floatFromInt(rl.getScreenHeight())),
            )) {
                circle.pos.y = posY;
            }
            yOffset += spacing;

            // Speed controls
            var speedX = circle.speed.x;
            var speedY = circle.speed.y;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "X Speed",
                "",
                &speedX,
                -5.0,
                5.0,
            )) {
                circle.speed.x = speedX;
            }
            yOffset += spacing;

            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Y Speed",
                "",
                &speedY,
                -5.0,
                5.0,
            )) {
                circle.speed.y = speedY;
            }
            yOffset += spacing;

            // Radius control
            var radius = circle.radius;
            if (1 == rg.guiSliderBar(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 20 },
                "Radius",
                "",
                &radius,
                10,
                100,
            )) {
                circle.radius = radius;
            }
            yOffset += spacing;

            // Color controls
            var color = circle.color;
            if (1 == rg.guiColorPicker(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 150, .height = 150 },
                "Color",
                &color,
            )) {
                circle.color = color;
            }
            yOffset += 160;

            // Visibility toggle
            var visible = circle.shouldDraw;
            if (1 == rg.guiCheckBox(
                rl.Rectangle{ .x = panelRect.x + 10, .y = yOffset, .width = 20, .height = 20 },
                "Visible",
                &visible,
            )) {
                circle.shouldDraw = visible;
            }
        },
    }
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

    var selectedShape: SelectedShape = .{ .rectangle = &config.rectangles.items[0] };

    while (!rl.windowShouldClose()) {
        const wWidth = rl.getScreenWidth();
        const wHeight = rl.getScreenHeight();

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            const mousePos = rl.getMousePosition();

            for (config.circles.items) |*circle| {
                if (isPointInCircle(mousePos, circle)) {
                    selectedShape = .{ .circle = circle };
                    break;
                }
            }

            for (config.rectangles.items) |*rect| {
                if (isPointInRectangle(mousePos, rect)) {
                    selectedShape = .{ .rectangle = rect };
                    break;
                }
            }
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        for (config.rectangles.items) |*rect| {
            updateRectangle(rect, wWidth, wHeight);
            drawRectangle(rect, font, config.font.size);
        }

        for (config.circles.items) |*circle| {
            updateCircle(circle, wWidth, wHeight);
            drawCircle(circle, font, config.font.size);
        }

        drawShapeControls(selectedShape);
    }
}
