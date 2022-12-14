const std = @import("std");

const zig_bearssl_build = @import("deps/zig-bearssl/build.zig");
const zig_http_build = @import("deps/zig-http/build.zig");

const PROJECT_NAME = "sol";

pub fn build(b: *std.build.Builder) void
{
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});
    const isDebug = mode == .Debug;

    const installDirRoot = std.build.InstallDir {
        .custom = "",
    };

    const server = b.addExecutable(PROJECT_NAME, "src/server_main.zig");
    server.setBuildMode(mode);
    server.setTarget(target);
    const configSrc = if (isDebug) "src/config_debug.zig" else "src/config_release.zig";
    server.addPackagePath("config", configSrc);
    zig_bearssl_build.addLib(server, target, "deps/zig-bearssl");
    zig_http_build.addLibClient(server, target, "deps/zig-http");
    zig_http_build.addLibCommon(server, target, "deps/zig-http");
    zig_http_build.addLibServer(server, target, "deps/zig-http");
    server.linkLibC();
    server.override_dest_dir = installDirRoot;
    server.install();

    const wasm = b.addSharedLibrary(PROJECT_NAME, "src/main.zig", .unversioned);
    wasm.setBuildMode(mode);
    wasm.setTarget(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });
    wasm.override_dest_dir = installDirRoot;
    wasm.install();

    const installDirScripts = std.build.InstallDir {
        .custom = "scripts",
    };
    b.installDirectory(.{
        .source_dir = "scripts",
        .install_dir = installDirScripts,
        .install_subdir = "",
    });

    const installDirStatic = std.build.InstallDir {
        .custom = "static",
    };
    b.installDirectory(.{
        .source_dir = "static",
        .install_dir = installDirStatic,
        .install_subdir = "",
    });

    const runTests = b.step("test", "Run tests");
    const testSrcs = [_][]const u8 {
        "src/server_main.zig",
    };
    for (testSrcs) |src| {
        const tests = b.addTest(src);
        tests.setBuildMode(mode);
        tests.setTarget(target);
        zig_bearssl_build.addLib(tests, target, "deps/zig-bearssl");
        zig_http_build.addLibClient(tests, target, "deps/zig-http");
        zig_http_build.addLibCommon(tests, target, "deps/zig-http");
        tests.linkLibC();
        runTests.dependOn(&tests.step);
    }
}
