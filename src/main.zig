const std = @import("std");
const zts = @import("zts");
const zmd = @import("zmd");
const config = @import("config");
const pages = @import("./pages.zig");

var gpa = std.heap.DebugAllocator(.{}).init;
const allocator = gpa.allocator();

const out_dir = config.install_prefix;

pub const Article = struct {
    id: []const u8,
    name: []const u8,
    date: []const u8,
    content: []const u8,
};

pub const Project = struct {
    cover_image_path: []const u8,
    description: []const u8,
    article: Article,
};

pub fn main() !void {
    try generate();
}

fn generate() !void {
    try generateIndex();

    inline for (pages.articles) |article| {
        try generateArticle(article);
    }
}

fn generateIndex() !void {
    const home_tmpl = @embedFile("./templates/home.html");

    var home_str = std.ArrayList(u8).empty;
    defer home_str.deinit(allocator);
    const writer = home_str.writer(allocator);

    try zts.writeHeader(home_tmpl, writer);

    // Project cards
    if (pages.projects.len > 0) {
        try zts.print(home_tmpl, "section", .{ "Projects", "Projects" }, writer);
        inline for (pages.projects) |project| {
            try generateArticle(project.article);
            try zts.print(home_tmpl, "project", .{
                project.cover_image_path,
                "./" ++ project.article.id ++ ".html",
                project.article.name,
                project.description,
            }, writer);

            try zts.write(home_tmpl, "projectend", writer);
        }
        try zts.write(home_tmpl, "sectionend", writer);
    }

    // Article links
    if (pages.articles.len > 0) {
        try zts.print(home_tmpl, "section", .{ "Articles", "Articles" }, writer);
        inline for (pages.articles) |article| {
            try zts.print(home_tmpl, "article", .{ article.id, article.name, article.date }, writer);
        }
        try zts.write(home_tmpl, "sectionend", writer);
    }

    try zts.write(home_tmpl, "end", writer);

    try generatePage("/index.html", home_str.items);
}

fn generateArticle(comptime article: Article) !void {
    const path = "/" ++ article.id ++ ".html";

    const content = "#" ++ article.name ++ "\n" ++ article.date ++ "\n" ++ article.content;

    const html = try zmd.parse(allocator, content, .{});
    try generatePage(path, html);
}

fn generatePage(comptime path: []const u8, content: []const u8) !void {
    const page_tmpl = @embedFile("./templates/page.html");

    const file = try std.fs.cwd().createFile(out_dir ++ path, .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var writer = file.writer(&buffer);
    const out = &writer.interface;

    try zts.writeHeader(page_tmpl, out);

    try zts.write(page_tmpl, "header", out);
    try zts.print(page_tmpl, "content", .{content}, out);
    try zts.write(page_tmpl, "footer", out);

    try out.flush();
}
