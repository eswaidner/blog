const std = @import("std");
const zts = @import("zts");
const zmd = @import("zmd");
const config = @import("config");

var gpa = std.heap.DebugAllocator(.{}).init;
const allocator = gpa.allocator();

const out_dir = config.install_prefix ++ "/site";

const Article = struct {
    id: []const u8,
    name: []const u8,
    date: []const u8,
    content: []const u8,
};

const Project = struct {
    cover_image_path: []const u8,
    tags: [][]const u8,
    article: Article,
};

const articles = [_]Article{
    .{ .id = "test", .name = "Test", .date = "", .content = @embedFile("./articles/test.md") },
};

const projects = [_]Project{};

pub fn main() !void {
    try generate();
}

fn generate() !void {
    try generateIndex();

    inline for (articles) |article| {
        try generateArticle(article);
    }
}

fn generateIndex() !void {
    try generatePage("/index.html", "Index");

    //TODO about me section

    //TODO articles section

    //TODO projects section
}

fn generateArticle(comptime article: Article) !void {
    const path = "/" ++ article.id ++ ".html";
    const html_content = try zmd.parse(allocator, article.content, .{});
    try generatePage(path, html_content);
}

fn generatePage(comptime path: []const u8, content: []const u8) !void {
    const page_tmpl = @embedFile("./templates/page.html");

    const file = try std.fs.cwd().createFile(out_dir ++ path, .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var writer = file.writer(&buffer);
    const out = &writer.interface;

    try zts.writeHeader(page_tmpl, out);
    try zts.print(page_tmpl, "content", .{content}, out);

    //TODO social links, copyright notice
    try zts.print(page_tmpl, "footer", .{"Footer"}, out);

    try out.flush();
}
