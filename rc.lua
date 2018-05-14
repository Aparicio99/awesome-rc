awful = require("awful")
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
async = awful.spawn.easy_async
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
require("battery")
require("wifi")
require("system")
require("mpd")
require("clock")
require("dropdown")
require("clipboard")
require("conky")

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
naughty.config.presets.normal.position = "top_right"
naughty.config.presets.low.screen = 1
naughty.config.presets.critical.screen = 1

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[2])
end
-- }}}

mpd_widget     = mpd.init()
volume_widget  = volume.init()
battery_widget = battery.init()
wifi_widget    = wifi.init()
system_widget  = system.init()
clock_widget   = clock.init()
conky_toggle   = conky.init()
blank1         = wibox.widget.textbox()
blank2         = wibox.widget.textbox()

blank1.text =" "
blank2.text = "  "

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
awful.screen.connect_for_each_screen(function(s)

    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(mylayoutbox.buttons)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Widgets that are aligned to the left
    local main_left_layout = wibox.layout.fixed.horizontal()
    main_left_layout:add(s.mylayoutbox)
    main_left_layout:add(blank1)
    main_left_layout:add(s.mytaglist)
    --main_left_layout:add(blank1)
    main_left_layout:add(s.promptbox)

    -- Widgets that are aligned to the right
    local main_right_layout = wibox.layout.fixed.horizontal()
    if s.index == 1 then
        main_right_layout:add(wibox.widget.systray())
    end
    main_right_layout:add(blank2)
    if battery.present() then
	    main_right_layout:add(battery_widget)
	    main_right_layout:add(blank2)
	    main_right_layout:add(wifi_widget)
	    main_right_layout:add(blank2)
	    main_right_layout:add(system_widget)
    main_right_layout:add(blank2)
    end
    main_right_layout:add(volume_widget)
    main_right_layout:add(blank2)
    if mpd.present() then
	    main_right_layout:add(mpd_widget)
	    main_right_layout:add(blank2)
    end
    main_right_layout:add(clock_widget)
    main_right_layout:add(conky_toggle)

    -- Now bring it all together (with the tasklist in the middle)
    local main_layout = wibox.layout.align.horizontal()
    main_layout.left = main_left_layout
    main_layout.middle = s.mytasklist
    main_layout.right = main_right_layout

    s.main_panel = awful.wibar({ position = "top", screen = s})
    s.main_panel.widget = main_layout
end)

-- }}}

--------------------------------------- Bindinds ------------------------------------
require("binds")
--
--------------------------------------- Rules ------------------------------------
require("rules")

--------------------------------------- Signals ---------------------------------------
client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c)
			           if c.type ~= "desktop" then
                                       c.border_color = beautiful.border_focus
                                   end
                               end)
client.connect_signal("unfocus", function(c)
                                     if c.type ~= "desktop" then
                                         c.border_color = beautiful.border_normal
                                     end
                                 end)

-- vim:ts=4:sw=4
