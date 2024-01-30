pub const Vaxis = @import("vaxis.zig").Vaxis;
pub const Options = @import("Options.zig");

const cell = @import("cell.zig");
pub const Cell = cell.Cell;
pub const Style = cell.Style;

pub const Key = @import("Key.zig");
pub const Winsize = @import("Tty.zig").Winsize;

pub const widgets = @import("widgets/main.zig");

pub const Image = @import("image/image.zig").Image;

/// Initialize a Vaxis application.
pub fn init(comptime EventType: type, opts: Options) !Vaxis(EventType) {
    return Vaxis(EventType).init(opts);
}

test {
    _ = @import("GraphemeCache.zig");
    _ = @import("Key.zig");
    _ = @import("Mouse.zig");
    _ = @import("Options.zig");
    _ = @import("Parser.zig");
    _ = @import("Screen.zig");
    _ = @import("Tty.zig");
    _ = @import("Window.zig");
    _ = @import("cell.zig");
    _ = @import("ctlseqs.zig");
    _ = @import("event.zig");
    _ = @import("gwidth.zig");
    _ = @import("image/image.zig");
    _ = @import("queue.zig");
    _ = @import("vaxis.zig");
}
