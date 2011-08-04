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

--------------------------------------- Includes ---------------------------------------
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

--------------------------------------- Widgets ---------------------------------------
plusmenu	= widget({type = "textbox"})
conky_toggle	= widget({type = "textbox"})
systray		= widget({type = "systray"})
blank1		= widget({type = "textbox"})
blank2		= widget({type = "textbox"})
mpd_widget	= mpd.init()
battery_widget	= battery.init()
volume_widget	= volume.init()
clock_widget	= clock.init()


--------------------------------------- Panel ---------------------------------------

blank1.text = " "
blank2.text = "  "

-- Browser mouse actions
plusmenu.text = "+ "
plusmenu:buttons(awful.util.table.join(
				awful.button({ }, 1, lspawn(browser.." -U")),
				awful.button({ }, 2, function() clipmenu:toggle()  end),
				awful.button({ }, 3, function() browsermenu:toggle()  end)))

conky_toggle.text = " "
conky_toggle:buttons(awful.util.table.join(awful.button({ }, 1,
				function()
					local c = getclient("instance", "Conky")
					if not c then
						spawn("conky")
					else
						c:kill()
					end
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
					function (c)
						if not c:isvisible() then awful.tag.viewonly(c:tags()[1]) end
						client.focus = c
						c:raise()
					end),
			awful.button({ }, 2, function (c) c:kill() end),
			awful.button({ }, 3, function (c) c.minimized = not c.minimized end),
			awful.button({ }, 4,
					function ()
						awful.client.focus.byidx(1)
						if client.focus then client.focus:raise() end
					end),
			awful.button({ }, 5,
					function ()
						awful.client.focus.byidx(-1)
						if client.focus then client.focus:raise() end
					end))

-- Run Prompt
mypromptbox = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

panel = {}
control = {}
layoutbox = {}
for s = 1, screen.count() do

	-- Layout box
	layoutbox[s] = awful.widget.layoutbox(s)
	layoutbox[s]:buttons(awful.util.table.join(
				awful.button({ }, 1, function () mainmenu:toggle() end),
				awful.button({ }, 2, function () awful.layout.set(awful.layout.suit.floating) end),
				awful.button({ }, 3, function () awful.layout.set(awful.layout.suit.tile) end),
				awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
				awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
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
		s == MAIN and blank1 or nil,
		s == MAIN and systray or nil,
		s == MAIN and blank1 or nil,
		s == MAIN and mypromptbox or nil,
		mytasklist[s],
		layout = awful.widget.layout.horizontal.rightleft
	}

	control[s] = awful.wibox({ position = "top", screen = s, ontop = false, width = 200, x = screen[s].geometry.width - 200})
	control[s].widgets = {
		s == MAIN and conky_toggle or nil,
		s == MAIN and clock_widget or nil,
		s == MAIN and blank2 or nil,
		s == MAIN and volume_widget or nil,
		s == MAIN and blank2 or nil,
		s == MAIN and battery_widget or nil,
		s == MAIN and mpd_widget or nil,
		layout = awful.widget.layout.horizontal.rightleft
	}
end

--------------------------------------- Root Mouse Bindings ---------------------------------------
root.buttons(awful.util.table.join(
			awful.button({     }, 3, function(c) mainmenu:toggle() end),
			awful.button({     }, 4, awful.tag.viewnext),
			awful.button({     }, 5, awful.tag.viewprev),
			awful.button({ Win }, 4, awful.tag.viewnext),
			awful.button({ Win }, 5, awful.tag.viewprev)
			))

--------------------------------------- Global Key Bindings ---------------------------------------
globalkeys = awful.util.table.join(
		-- Generic
		awful.key({ Win,     }, "Menu",  function () mainmenu:toggle() end),
		awful.key({ Win, Alt }, "Menu",  function () awful.menu.clients({keygrabber=true}) end),
		awful.key({ Win, Ctr }, "r",     awesome.restart),
		awful.key({ Win, Ctr }, "q",	 awesome.quit),

		-- Tag navegation
		awful.key({ Win,     }, "Left",  awful.tag.viewprev ),
		awful.key({ Win,     }, "Right", awful.tag.viewnext ),
		awful.key({ Win,     }, "\\",    awful.tag.history.restore ),
		awful.key({ Win,     }, "Tab",   awful.tag.viewnext ),
		awful.key({ Win, Shi }, "Tab",   awful.tag.viewprev ),
		awful.key({ Win,     }, "Up",    function () awful.screen.focus_relative( 1) end),
		awful.key({ Win,     }, "Down",  function () awful.screen.focus_relative(-1) end),
		awful.key({ Win,     }, "<",     function () awful.screen.focus_relative( 1) end),
		awful.key({ Win, Shi }, "<",     function () awful.screen.focus_relative(-1) end),

		-- Layout navegation
		awful.key({ Win,     }, "u",     awful.client.urgent.jumpto ),
		awful.key({ Alt      }, "\\",
						function ()
							awful.client.focus.history.previous()
							if client.focus then client.focus:raise() end
						end),
		awful.key({ Alt      }, "Tab",
						function ()
							awful.client.focus.byidx(1)
							if client.focus then client.focus:raise() end
						end),
		awful.key({ Alt, Shi }, "Tab",
						function ()
							awful.client.focus.byidx(-1)
							if client.focus then client.focus:raise() end
						end),

		-- Layout manipulation
		awful.key({ Win, Alt }, "Left",  function() awful.tag.incnmaster( 1)      layoutinfo() end),
		awful.key({ Win, Alt }, "Right", function() awful.tag.incnmaster(-1)      layoutinfo() end),
		awful.key({ Win, Alt }, "Up",    function() awful.client.swap.byidx( 1)   layoutinfo() end),
		awful.key({ Win, Alt }, "Down",  function() awful.client.swap.byidx(-1)   layoutinfo() end),
		awful.key({ Win, Ctr }, "Left",  function() incmwfact5(-0.05)             layoutinfo() end),
		awful.key({ Win, Ctr }, "Right", function() incmwfact5(0.05)              layoutinfo() end),
		awful.key({ Win, Shi }, "0",     function() awful.tag.setmwfact(0.5)      layoutinfo() end),
		awful.key({ Win, Shi }, "\'",    function() awful.tag.setmwfact(0.75)     layoutinfo() end),
		awful.key({ Win, Ctr }, "Up",    function() awful.tag.incncol( 1)         layoutinfo() end),
		awful.key({ Win, Ctr }, "Down",  function() awful.tag.incncol(-1)         layoutinfo() end),
		awful.key({ Win,     }, "space", function() awful.layout.inc(layouts,  1) layoutinfo() end),
		awful.key({ Win, Shi }, "space", function() awful.layout.inc(layouts, -1) layoutinfo() end),

		-- Apps
		awful.key({ Win }, "Return",               lspawn(terminal)),
		awful.key({ Win, Alt }, "Return",          lspawn(terminal.." -e su")),
		awful.key({     }, "Print",                lspawn("/home/aparicio/scripts/screenshot scr")),
		awful.key({ Ctr }, "Print",                lspawn("/home/aparicio/scripts/screenshot area")),
		awful.key({     }, "XF86WWW",              lspawn(browser)),
		awful.key({     }, "XF86Display",          lspawn("xset dpms force off")),
		awful.key({     }, "Pause",                function () spawn("xset dpms force off") mpd.stop() end),
		awful.key({     }, "XF86AudioMute",        volume.toggle),
		awful.key({     }, "XF86AudioRaiseVolume", volume.inc),
		awful.key({     }, "XF86AudioLowerVolume", volume.dec),
		awful.key({ Win }, "KP_Add",               volume.inc),
		awful.key({ Win }, "KP_Subtract",          volume.dec),
		awful.key({ Win }, "KP_Multiply",          volume.toggle),
		awful.key({ Win }, "KP_Divide",            volume.check),
		awful.key({ Win }, "Home",                 mpd.prev),
		awful.key({ Win }, "End",                  mpd.next),
		awful.key({ Win }, "Insert",               mpd.toggle),
		awful.key({ Win }, "Delete",               mpd.stop),
		awful.key({     }, "XF86AudioPlay",	   function () volume.check() mpd.toggle() end),
		awful.key({     }, "XF86AudioStop",        mpd.stop),
		awful.key({     }, "XF86AudioPrev",        mpd.prev),
		awful.key({     }, "XF86AudioNext",        mpd.next),
		awful.key({     }, "XF86MonBrightnessUp",  lspawn("xbacklight +10")),
		awful.key({     }, "XF86MonBrightnessDown",lspawn("xbacklight -10")),
		awful.key({ Win }, "e",                    lspawn("xscreensaver-command -lock")),
		awful.key({ Win }, "F1",                   function () drop.toggle(3) end),
		awful.key({ Win }, "F3",                   drop.onoff),
		awful.key({ Alt }, "F2",		   dmenu),
		awful.key({ Win }, "b",                    lspawn("/home/aparicio/scripts/luakit_bookmark")),
		awful.key({ Win }, "s",                    clipboard.seltocli),
		awful.key({ Win }, "c",                    clipboard.clitosel),

		-- Prompts
		awful.key({ Win }, "r",	function () mypromptbox:run() end ),
		awful.key({ Win }, "x",	mkprompt("Lua: ",  awful.util.eval, cache.."/history_eval") ),
		awful.key({ Win }, "F11", mkprompt("Calc: ", function (s) out("= " .. awful.util.eval("return (" .. s .. ")")) end ) ),
		awful.key({ Win }, "XF86AudioPlay", mkprompt("mpc ", function (s) mpd.cmd(s, 10)() end, cache.."/history_mpc") )
)

--------------------------------------- Numeric Tag Switching ---------------------------------------
for i = 1, 4 do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ Win },      "#"..i+9, function () awful.tag.viewonly(tags[mouse.screen][i]) end),
		awful.key({ Win, Ctr }, "#"..i+9, function () awful.tag.viewtoggle(tags[mouse.screen][i]) end),
		awful.key({ Win, Shi }, "#"..i+9, function () awful.client.movetotag(tags[client.focus.screen][i]) end),
		awful.key({ Win, Alt }, "#"..i+9, function () awful.client.toggletag(tags[client.focus.screen][i]) end))
end

--------------------------------------- Dynamic key bindings ---------------------------------------
globalkeys = awful.util.table.join(globalkeys,
	awful.key({ }, "F1", function () drop.toggle(1) end),
	awful.key({ }, "F2", function () drop.toggle(2) end))

root.keys(globalkeys)

--------------------------------------- Client key bindings ---------------------------------------
clientkeys = awful.util.table.join(
		awful.key({ Alt      }, "F4",     function (c) c:kill() end),
		awful.key({ Win      }, "p",      function (c) c.sticky = not c.sticky end),
		awful.key({ Win,     }, "f",      function (c) c.fullscreen = not c.fullscreen end),
		awful.key({ Win, Alt }, "space",  awful.client.floating.toggle ),
		awful.key({ Win, Ctr }, "Return", function (c) c:swap(awful.client.getmaster()) end),
		awful.key({ Win,     }, "o",      awful.client.movetoscreen ),
		awful.key({ Win, Alt }, "r",      function (c) c:redraw() end),
		awful.key({ Win,     }, "t",      function (c) c.ontop = not c.ontop end),
		awful.key({ Win,     }, "n",      function (c) c.minimized = not c.minimized end),
		awful.key({ Win, Shi }, "Right",  shift_to_tag(1)),
		awful.key({ Win, Shi }, "Left",   shift_to_tag(-1)),
		awful.key({ Win,     }, "i",      client_info),
		awful.key({ Win,     }, "m",	  function (c)
							c.maximized_horizontal = not c.maximized_horizontal
							c.maximized_vertical   = not c.maximized_vertical
						  end)
)

--------------------------------------- Client mouse actions ---------------------------------------
clientbuttons = awful.util.table.join(
		awful.button({     }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ Win }, 1, awful.mouse.client.move),
		awful.button({ Win }, 2, function (c) c:kill() end),
		awful.button({ Win }, 3, awful.mouse.client.resize),
		awful.button({ Win }, 4, awful.tag.viewnext),
		awful.button({ Win }, 5, awful.tag.viewprev))

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
	{ rule = { class = "Skype" },	properties = { tag = tags[MAIN][1] } },
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
			--c:geometry( { x = w_area.width - strutwidth, width = strutwidth, y = w_area.y, height = w_area.height } )
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

