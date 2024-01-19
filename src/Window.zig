const std = @import("std");

const Screen = @import("Screen.zig");
const Cell = @import("cell.zig").Cell;

const Window = @This();

pub const Size = union(enum) {
    expand,
    limit: usize,
};

/// horizontal offset from the screen
x_off: usize,
/// vertical offset from the screen
y_off: usize,
/// width of the window. This can't be larger than the terminal screen
width: usize,
/// height of the window. This can't be larger than the terminal screen
height: usize,

screen: *Screen,

/// Creates a new window with offset relative to parent and size clamped to the
/// parent's size. Windows do not retain a reference to their parent and are
/// unaware of resizes.
pub fn initChild(
    self: *Window,
    x_off: usize,
    y_off: usize,
    width: Size,
    height: Size,
) Window {
    const resolved_width = switch (width) {
        .expand => self.width - x_off,
        .limit => |w| blk: {
            if (w + x_off > self.width) {
                break :blk self.width - x_off;
            }
            break :blk w;
        },
    };
    const resolved_height = switch (height) {
        .expand => self.height - y_off,
        .limit => |h| blk: {
            if (h + y_off > self.height) {
                break :blk self.height - y_off;
            }
            break :blk h;
        },
    };
    return Window{
        .x_off = x_off + self.x_off,
        .y_off = y_off + self.y_off,
        .width = resolved_width,
        .height = resolved_height,
        .screen = self.screen,
    };
}

/// writes a cell to the location in the window
pub fn writeCell(self: Window, cell: Cell, row: usize, col: usize) void {
    if (self.h < row or self.w < col) return;
    self.screen.writeCell(cell, row + self.y_off, col + self.x_off);
}

test "Window size set" {
    var parent = Window{
        .x_off = 0,
        .y_off = 0,
        .width = 20,
        .height = 20,
        .screen = undefined,
    };

    const child = parent.initChild(1, 1, .expand, .expand);
    try std.testing.expectEqual(19, child.width);
    try std.testing.expectEqual(19, child.height);
}

test "Window size set too big" {
    var parent = Window{
        .x_off = 0,
        .y_off = 0,
        .width = 20,
        .height = 20,
        .screen = undefined,
    };

    const child = parent.initChild(0, 0, .{ .limit = 21 }, .{ .limit = 21 });
    try std.testing.expectEqual(20, child.width);
    try std.testing.expectEqual(20, child.height);
}

test "Window size set too big with offset" {
    var parent = Window{
        .x_off = 0,
        .y_off = 0,
        .width = 20,
        .height = 20,
        .screen = undefined,
    };

    const child = parent.initChild(10, 10, .{ .limit = 21 }, .{ .limit = 21 });
    try std.testing.expectEqual(10, child.width);
    try std.testing.expectEqual(10, child.height);
}

test "Window size nested offsets" {
    var parent = Window{
        .x_off = 1,
        .y_off = 1,
        .width = 20,
        .height = 20,
        .screen = undefined,
    };

    const child = parent.initChild(10, 10, .{ .limit = 21 }, .{ .limit = 21 });
    try std.testing.expectEqual(11, child.x_off);
    try std.testing.expectEqual(11, child.y_off);
}