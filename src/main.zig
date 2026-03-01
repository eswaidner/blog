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
    description: []const u8,
    article: Article,
};

const projects = [_]Project{
    .{
        .cover_image_path = "./assets/drone-fleet-thumb.webp",
        .description = "Build fleets of autonomous drones using simulated parts",
        .article = .{
            .id = "drone-fleet",
            .name = "Drone Fleet",
            .date = "Feb 28, 2026",
            .content = @embedFile("./articles/drone-fleet.md"),
        },
    },
    .{
        .cover_image_path = "./assets/aquitech-thumb.webp",
        .description = "Build a submarine and battle other players in online matches",
        .article = .{
            .id = "aquitech",
            .name = "Aquitech",
            .date = "Feb 28, 2026",
            .content = @embedFile("./articles/aquitech.md"),
        },
    },
};

const articles = [_]Article{
    .{
        .id = "test",
        .name = "Test",
        .date = "Feb 28, 2026",
        .content = @embedFile("./articles/test.md"),
    },
    .{
        .id = "test-2",
        .name = "Test with a Really Really Long Name",
        .date = "Feb 29, 2026",
        .content = @embedFile("./articles/test.md"),
    },
    .{
        .id = "test-3",
        .name = "Test",
        .date = "Feb 28, 2026",
        .content = @embedFile("./articles/test.md"),
    },
};

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
    const home_tmpl = @embedFile("./templates/home.html");

    var home_str = std.ArrayList(u8).empty;
    defer home_str.deinit(allocator);
    const writer = home_str.writer(allocator);

    try zts.writeHeader(home_tmpl, writer);

    try zts.print(home_tmpl, "section", .{ "Projects", "Projects" }, writer);
    inline for (projects) |project| {
        try generateArticle(project.article);
        try zts.print(home_tmpl, "project", .{
            project.cover_image_path,
            out_dir ++ "/" ++ project.article.id ++ ".html",
            project.article.name,
            project.description,
        }, writer);

        try zts.write(home_tmpl, "projectend", writer);
    }
    try zts.write(home_tmpl, "sectionend", writer);

    try zts.print(home_tmpl, "section", .{ "Articles", "Articles" }, writer);
    inline for (articles) |article| {
        try zts.print(home_tmpl, "article", .{ article.id, article.name, article.date }, writer);
    }
    try zts.write(home_tmpl, "sectionend", writer);

    try zts.write(home_tmpl, "end", writer);

    try generatePage("/index.html", home_str.items);

    //TODO about me section

    //TODO articles section

    //TODO projects section
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
