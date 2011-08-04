require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")

config = awful.util.getdir("config")
cache = awful.util.getdir("cache")
beautiful.init(config .. "/themes/green/theme.lua")

--------------------------------------- Alias ---------------------------------------
spawn = awful.util.spawn
pread = awful.util.pread
Win = "Mod4"
Alt = "Mod1"
Ctr = "Control"
Shi = "Shift"
scripts = "/home/aparicio/scripts/"
terminal = scripts.."uterm"
browser = "luakit"

--------------------------------------- External files -------------------------------
require("helpers")
require("clock")
require("volume")
require("battery")
require("mpd")
require("dropdown")
require("clipboard")
require("menu")

--------------------------------------- Layout ---------------------------------------
layouts = {
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

if screen.count() == 2 then MAIN = 2 else MAIN = 1 end

naughty.config.presets.normal.font = "Monospace 8"
naughty.config.presets.normal.screen = MAIN
naughty.config.presets.low.screen = MAIN
naughty.config.presets.critical.screen = MAIN

-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	tags[s] = awful.tag({ 1, 2, 3, 4 }, s, awful.layout.suit.tile)
end

awful.tag.setproperty(tags[MAIN][1], "mwfact", 0.75)
awful.tag.setproperty(tags[1][2], "layout", awful.layout.suit.max)

--------------------------------------- Panel ---------------------------------------

-- Widgets
plusmenu	= widget({type = "textbox"})
conky_toggle	= widget({type = "textbox"})
systray		= widget({type = "systray"})
blank1		= widget({type = "textbox"})
blank2		= widget({type = "textbox"})
mpd_widget	= mpd.init()
battery_widget	= battery.init()
volume_widget	= volume.init()
clock_widget	= clock.init()

blank1.text = " "
blank2.text = "  "

-- Plus button mouse actions
plusmenu.text = "+ "
plusmenu:buttons(awful.util.table.join(
				awful.button({ }, 1, lspawn(browser.." -U")),
				awful.button({ }, 2, function() clipmenu:toggle()  end),
				awful.button({ }, 3, function() browsermenu:toggle()  end)))

-- Hidden button to toggle conky
conky_toggle.text = " "
conky_toggle:buttons(awful.util.table.join(awful.button({ }, 1,
				function()
					local c = getclient("instance", "Conky")
					if not c then spawn("conky")
					else c:kill() end
				end)))

-- Tag mouse actions
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
			awful.button({     }, 1, awful.tag.viewonly),
			awful.button({ Win }, 1, awful.client.movetotag),
			awful.button({     }, 3, awful.tag.viewtoggle),
			awful.button({ Win }, 3, awful.client.toggletag),
			awful.button({     }, 4, awful.tag.viewnext),
			awful.button({     }, 5, awful.tag.viewprev))

-- Task mouse actions
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
			awful.button({ }, 1,
					function (c) -- focus window
						if not c:isvisible() then awful.tag.viewonly(c:tags()[1]) end
						client.focus = c
						c:raise()
					end),
			awful.button({ }, 2, function (c) c:kill() end),
			awful.button({ }, 3, function (c) c.minimized = not c.minimized end),
			awful.button({ }, 4,
					function () -- changed focused client
						awful.client.focus.byidx(1)
						if client.focus then client.focus:raise() end
					end),
			awful.button({ }, 5,
					function () -- changed focused client
						awful.client.focus.byidx(-1)
						if client.focus then client.focus:raise() end
					end))

-- Layout box mouse actions
layoutbox = {}
layoutbox.buttons = awful.util.table.join(
			awful.button({ }, 1, function () mainmenu:toggle() end),
			awful.button({ }, 2, function () awful.layout.set(awful.layout.suit.floating) end),
			awful.button({ }, 3, function () awful.layout.set(awful.layout.suit.tile) end),
			awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))




-- Run Prompt
promptbox = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

panel = {}
control = {}
for s = 1, screen.count() do

	-- Layout box and Menu button
	layoutbox[s] = awful.widget.layoutbox(s)
	layoutbox[s]:buttons(layoutbox.buttons)

	-- Tag list
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

	-- Task list
	mytasklist[s] = awful.widget.tasklist( function(c) return awful.widget.tasklist.label.currenttags(c, s) end, mytasklist.buttons)

	-- Panel
	panel[s] = awful.wibox({ position = "top", screen = s, ontop = false, width = screen[s].geometry.width - 200})
	panel[s].widgets = {
		{
			layoutbox[s],
			mytaglist[s],
			s == 1 and plusmenu or nil,
			layout = awful.widget.layout.horizontal.leftright
		},
		s == MAIN and battery_widget or nil,
		s == MAIN and blank1 or nil,
		s == MAIN and systray or nil,
		s == MAIN and blank1 or nil,
		s == MAIN and promptbox or nil,
		mytasklist[s],
		layout = awful.widget.layout.horizontal.rightleft
	}

	-- Widgets panel
	control[s] = awful.wibox({ position = "top", screen = s, ontop = false, width = 200, x = screen[s].geometry.width - 200})
	control[s].widgets = {
		s == MAIN and conky_toggle or nil,
		s == MAIN and clock_widget or nil,
		s == MAIN and blank2 or nil,
		s == MAIN and volume_widget or nil,
		s == MAIN and blank2 or nil,
		s == MAIN and mpd_widget or nil,
		layout = awful.widget.layout.horizontal.rightleft
	}
end

--------------------------------------- Bindinds ------------------------------------
require("binds")

--------------------------------------- Rules ---------------------------------------
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },	properties = {	border_width = beautiful.border_width,
					border_color = beautiful.border_normal,
					focus = true,
					keys = clientkeys,
					buttons = clientbuttons,
					size_hints_honor = false} },
	-- Float
	{ rule_any = {	class = { "MPlayer", "gimp", "Gmpc", "Transmission" },
			name = { "File Transfers", "cal", "ncmpc", "puff" } },
			properties = { floating = true } },
	-- Drop consoles
	{ rule_any = {	instance = {"dropterm1", "dropterm2", "dropterm3"} },
			properties = { floating = true, ontop = true, skip_taskbar = true, sticky = true, hidden = true } },
	-- Other
	{ rule = { class = browser },	properties = { tag = tags[1][2] } },
	{ rule = { class = "Skype" },	properties = { floating = true, sticky = true } },
	{ rule = { class = "Claws-mail", role = "compose" }, properties = {  floating = true} },
	{ rule = { class = "Claws-mail", role = "mainwindow" }, properties = { maximized_horizontal = true, maximized_vertical = true} },
	{ rule = { class = "Boincmgr" }, properties = {  floating = true, skip_taskbar = true} },
	{ rule = { class = "Conky"  },
		properties = {
			floating = true,
			focus = false,
			skip_taskbar = true,
		},
		callback = function( c )
			local w_area = screen[ c.screen ].workarea
			local strutwidth = 200
			c:struts( { right = strutwidth } )
		end
	}
}

--------------------------------------- Signals ---------------------------------------
client.add_signal("manage",
	function (c, startup)
		if not startup then
			-- Put windows in a smart way, only if they does not
			-- set an initial position.
			if not (c.size_hints.user_position or c.size_hints.program_position) then
				awful.placement.no_overlap(c)
				awful.placement.no_offscreen(c)
			end
		end
	end )

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

