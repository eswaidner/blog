const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zts = b.dependency("zts", .{ .target = target, .optimize = optimize });

    const exe = b.addExecutable(.{
        .name = "blog",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zts", .module = zts.module("zts") }},
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    const install_dir = b.addInstallDirectory(.{
        .source_dir = b.path("./src/assets"),
        .install_dir = .prefix,
        .install_subdir = "site/assets",
    });
    b.getInstallStep().dependOn(&install_dir.step);

    const options = b.addOptions();
    options.addOption([]const u8, "install_prefix", b.install_prefix);
    exe.root_module.addOptions("config", options);

    if (b.args) |args| run_cmd.addArgs(args);
}
