const std = @import("std");

const Season = enum {
    Spring,
    Summer,
    Fall,
    Winter,
};

const Weather = enum {
    Sun,
    Rain,
    Wind,
    Snow,
    Storm,
};

const Calendar = struct {
    time: u32,
    season: Season,
    weather: Weather,
};

const ScheduleEntry = struct {
    calendar: Calendar,
    location: []const u8, // location name
    xPos: u32,
};

const Schedule = struct {
    entries: []ScheduleEntry,
};

const LocationLink = struct {
    sprite: []const u8,
    address: []const u8, // location name
};

const Location = struct {
    name: []const u8,
    sprite: []const u8,
    width: u32,
    height: u32,
    leftLocLinks: []LocationLink,
    rightLocLinks: []LocationLink,
};

const Building = struct {
    sprite: []const u8,
    location: []const u8, // location name
    xPos: u32,
    door: ?LocationLink,
};

const Character = struct {
    name: []const u8,
    sprite: []const u8,
    schedule: Schedule,
    // TODO dialog
};

const EconomyItem = struct {
    name: []const u8,
    sprite: []const u8,
    price: u32,
    description: []const u8,
    // TODO actions
};

const GameStatus = struct {
    calendar: Calendar,
    location: []const u8, // location name
    money: u32,
    inventory: []EconomyItem,
};

pub fn importFile(fileData: []const u8) !void
{
    std.log.info("importFile: {s}", .{fileData});
}
