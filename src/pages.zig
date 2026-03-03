const main = @import("./main.zig");

/// Articles with project cards in the "Projects" section.
pub const projects = [_]main.Project{
    .{
        .cover_image_path = "./assets/drone-fleet-thumb.webp",
        .description = "Build fleets of autonomous drones using simulated parts",
        .article = .{
            .id = "drone-fleet",
            .name = "Drone Fleet",
            .description = "Engineering/puzzle game where you build fleets of autonomous drones using simulated parts.",
            .date = "2023-2024",
            .content = @embedFile("./articles/drone-fleet.md"),
        },
    },
    .{
        .cover_image_path = "./assets/aquitech-thumb.webp",
        .description = "Build a submarine and battle other players in online matches",
        .article = .{
            .id = "aquitech",
            .name = "Aquitech",
            .description = "Online multiplayer PvP game where you build a submarine and battle other players.",
            .date = "2021",
            .content = @embedFile("./articles/aquitech.md"),
        },
    },
    .{
        .cover_image_path = "./assets/innovation-teams-thumb.webp",
        .description = "Innovation consulting for real-world clients",
        .article = .{
            .id = "innovation-teams",
            .name = "Innovation Teams",
            .description = "Innovation consulting projects for real-world clients as part of the UCCS Bachelor of Innovation program.",
            .date = "2024-2025",
            .content = @embedFile("./articles/innovation-teams.md"),
        },
    },
    .{
        .cover_image_path = "./assets/track-cycling-thumb.webp",
        .description = "Raced at a world-class level",
        .article = .{
            .id = "track-cycling",
            .name = "Track Cycling",
            .description = "Raced internationally as an athlete on the track cycling Olympic Development Program (ODP).",
            .date = "2016-2021",
            .content = @embedFile("./articles/track-cycling.md"),
        },
    },
};

/// Articles with links in the "Articles" section.
pub const articles = [_]main.Article{};
