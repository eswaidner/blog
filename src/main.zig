const std = @import("std");
const zts = @import("zts");
const config = @import("config");

const out_dir = config.install_prefix ++ "/site";

pub fn main() !void {
    try generate();
}

fn generate() !void {
    const page_tmpl = @embedFile("./templates/page.html");

    const file = try std.fs.cwd().createFile(out_dir ++ "/index.html", .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var writer = file.writer(&buffer);
    const out = &writer.interface;

    try zts.writeHeader(page_tmpl, out);
    try zts.print(page_tmpl, "body", .{"Hello Blog"}, out);

    try out.flush();
}
