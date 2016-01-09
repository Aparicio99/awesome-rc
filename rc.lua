gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
config = awful.util.getdir("config")
cache = awful.util.getdir("cache")
beautiful.init(config .. "/themes/custom/theme.lua")

-- This is used later as the default terminal and editor to run.
spawn = awful.util.spawn
pread = awful.util.pread
Win = "Mod4"
Alt = "Mod1"
Ctr = "Control"
Shi = "Shift"
browser = "Firefox"
scripts = "/home/aparicio/scripts/"
terminal = scripts.."uterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

require("helpers")
require("menu")
require("volume")
require("mpd")
require("clock")
require("dropdown")
require("clipboard")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

naughty.config.presets.normal.font = "Monospace 8"
naughty.config.presets.normal.border_color = beautiful.fg_focus
naughty.config.presets.normal.screen = 1
naughty.config.presets.low.screen = 1
naughty.config.presets.critical.screen = 1

-- {{{ Wallpaper
--if beautiful.wallpaper then
--    for s = 1, screen.count() do
--        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
--end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[2])
end
-- }}}

mpd_widget    = mpd.init()
volume_widget = volume.init()
clock_widget  = clock.init()
conky_toggle  = wibox.widget.textbox()
blank1        = wibox.widget.textbox()
blank2        = wibox.widget.textbox()

blank1:set_text(" ")
blank2:set_text("  ")

-- Hidden button to toggle conky
conky_toggle:set_text(" ")
conky_toggle:buttons(awful.util.table.join(awful.button({ }, 1,
				function()
					local c = getclient("instance", "Conky")
					if not c then spawn("conky")
					else c:kill() end
				end)))

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Create a wibox for each screen and add it
promptbox = {}

mylayoutbox = {}
mylayoutbox.buttons = awful.util.table.join(
                           awful.button({ }, 1, function () mainmenu:toggle() end),
                           awful.button({ }, 2, function () awful.layout.set(awful.layout.suit.floating) end),
                           awful.button({ }, 3, function () awful.layout.set(awful.layout.suit.tile) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))

mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({     }, 1, awful.tag.viewonly),
                    awful.button({ Win }, 1, awful.client.movetotag),
                    awful.button({     }, 3, awful.tag.viewtoggle),
                    awful.button({ Win }, 3, awful.client.toggletag),
                    awful.button({     }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({     }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c) -- focus window
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  client.focus = c
                                                  c:raise()
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, function (c) c.minimized = not c.minimized end),
                     awful.button({ }, 4, function () -- change focused client
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function () -- change focused client
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))
main_panel = {}
control_panel = {}

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    promptbox[s] = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(mylayoutbox.buttons)

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    main_panel[s] = awful.wibox({ position = "top", screen = s, ontop = false, width = screen[s].geometry.width - 200})

    -- Widgets that are aligned to the left
    local main_left_layout = wibox.layout.fixed.horizontal()
    main_left_layout:add(mylayoutbox[s])
    main_left_layout:add(mytaglist[s])
    main_left_layout:add(promptbox[s])

    -- Widgets that are aligned to the right
    local main_right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then main_right_layout:add(wibox.widget.systray()) end

    -- Now bring it all together (with the tasklist in the middle)
    local main_layout = wibox.layout.align.horizontal()
    main_layout:set_left(main_left_layout)
    main_layout:set_middle(mytasklist[s])
    main_layout:set_right(main_right_layout)

    main_panel[s]:set_widget(main_layout)


    control_panel[s] = awful.wibox({ position = "top", screen = s, ontop = false, width = 200, x = screen[s].geometry.width - 200})

    local control_right_layout = wibox.layout.fixed.horizontal()
    control_right_layout:add(clock_widget)
    control_right_layout:add(conky_toggle)

    local control_left_layout = wibox.layout.fixed.horizontal()
    control_left_layout:add(blank2)
    control_left_layout:add(mpd_widget)
    control_left_layout:add(blank2)
    control_left_layout:add(volume_widget)

    local control_layout = wibox.layout.align.horizontal()
    control_layout:set_left(control_left_layout)
    control_layout:set_right(control_right_layout)

    control_panel[s]:set_widget(control_layout)
end
-- }}}

--------------------------------------- Bindinds ------------------------------------
require("binds")
--
--------------------------------------- Rules ------------------------------------
require("rules")

--------------------------------------- Signals ---------------------------------------
client.connect_signal("manage", function (c, startup)

    if c.instance == "dropterm1" then
	    drop.setprop(c, 1, true)

    elseif c.instance == "dropterm2" then
	    drop.setprop(c, 2, true)

    elseif c.instance == "dropterm3" then
	    drop.setprop(c, 3, true)
    end

    if not startup then
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
