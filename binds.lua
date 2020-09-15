local hotkeys_popup = require("awful.hotkeys_popup").widget

--------------------------------------- Root Mouse Bindings ---------------------------------------
root.buttons(gears.table.join(
	awful.button({     }, 3, function(c) mainmenu:toggle() end),
	awful.button({     }, 4, awful.tag.viewnext),
	awful.button({     }, 5, awful.tag.viewprev),
	awful.button({ Win }, 4, awful.tag.viewnext),
	awful.button({ Win }, 5, awful.tag.viewprev)
))

--------------------------------------- Global Key Bindings ---------------------------------------
local globalkeys = gears.table.join(
	-- Generic
	awful.key({ Win,     }, "Menu",  function () mainmenu:toggle() end),
	awful.key({ Win, Alt }, "Menu",  function () awful.menu.clients({keygrabber=true}) end),
	awful.key({ Win,     }, "h",     hotkeys_popup.show_help ),
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
	awful.key({ Win, Shi }, "o",     swap_screens),

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
	awful.key({ Win, Alt }, "Left",  function() awful.tag.incnmaster( 1)    layoutinfo() end),
	awful.key({ Win, Alt }, "Right", function() awful.tag.incnmaster(-1)    layoutinfo() end),
	awful.key({ Win, Alt }, "Up",    function() awful.client.swap.byidx( 1) layoutinfo() end),
	awful.key({ Win, Alt }, "Down",  function() awful.client.swap.byidx(-1) layoutinfo() end),
	awful.key({ Win, Ctr }, "Left",  function() incmwfact5(-0.05)           layoutinfo() end),
	awful.key({ Win, Ctr }, "Right", function() incmwfact5(0.05)            layoutinfo() end),
	awful.key({ Win, Shi }, "0",     function() awful.tag.setmwfact(0.5)    layoutinfo() end),
	awful.key({ Win, Shi }, "\'",    function() awful.tag.setmwfact(0.75)   layoutinfo() end),
	awful.key({ Win, Ctr }, "Up",    function() awful.tag.incncol( 1)       layoutinfo() end),
	awful.key({ Win, Ctr }, "Down",  function() awful.tag.incncol(-1)       layoutinfo() end),
	awful.key({ Win,     }, "space", function() awful.layout.inc( 1)        layoutinfo() end),
	awful.key({ Win, Shi }, "space", function() awful.layout.inc(-1)        layoutinfo() end),

	-- Apps
	awful.key({ Win }, "Return",               lspawn(terminal)),
	awful.key({ Win, Alt }, "Return",          lspawn(terminal.." -e su")),
	awful.key({     }, "Print",                lspawn("screenshot scr")),
	awful.key({ Ctr }, "Print",                lspawn("screenshot area")),
	awful.key({     }, "XF86Display",          lspawn("xset dpms force off")),
	awful.key({     }, "Pause",                sleep),
	awful.key({ Win }, "l",                    sleep),
	awful.key({     }, "XF86AudioMute",        volume.toggle),
	awful.key({     }, "XF86AudioRaiseVolume", volume.inc),
	awful.key({     }, "XF86AudioLowerVolume", volume.dec),
	awful.key({ Win }, "+",                    volume.inc),
	awful.key({ Win }, "-",                    volume.dec),
	awful.key({ Win }, "KP_Add",               volume.inc),
	awful.key({ Win }, "KP_Subtract",          volume.dec),
	awful.key({ Win }, "KP_Multiply",          volume.toggle),
	awful.key({ Win }, "KP_Divide",            volume.check),
	awful.key({ Win }, "Home",                 music.prev),
	awful.key({ Win }, "End",                  music.next),
	awful.key({ Win }, "Insert",               music.toggle),
	awful.key({ Win }, "Delete",               music.stop),
	awful.key({     }, "XF86AudioPlay",        function () volume.check() music.toggle() end),
	awful.key({     }, "XF86AudioStop",        music.stop),
	awful.key({     }, "XF86AudioPrev",        music.prev),
	awful.key({     }, "XF86AudioNext",        music.next),
	awful.key({     }, "XF86MonBrightnessUp",  lspawn("xbacklight -inc 10")),
	awful.key({     }, "XF86MonBrightnessDown",lspawn("xbacklight -dec 10")),
	awful.key({ Win }, "e",                    lspawn("xscreensaver-command -lock")),
	awful.key({ Win }, "F1",                   function () dropdown.toggle(3) end),
	awful.key({ Win }, "F3",                   dropdown.onoff),
	awful.key({ Alt }, "F2",                   function () menubar.show() end),
	awful.key({ Win }, "s",                    clipboard.seltocli),
	awful.key({ Win }, "c",                    clipboard.clitosel),

	-- Prompts
	awful.key({ Win }, "r",	function () awful.screen.focused().promptbox:run() end ),

	awful.key({ Win }, "x",	mkprompt("Lua: ",
		awful.util.eval, cache.."/history_eval") ),

	awful.key({ Win }, "F11", mkprompt("Calc: ",
		function (s) out("= " .. awful.util.eval("return (" .. s .. ")")) end ) )
)

--------------------------------------- Numeric Tag Switching ---------------------------------------


for i = 1, NUM_TAGS do
	globalkeys = gears.table.join(globalkeys,

		awful.key({ Win }, "#"..i+9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
				   tag:view_only()
				end

			end,
			{description = "view tag #"..i, group = "tag"}),

		awful.key({ Win, Ctr }, "#"..i+9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tag"}),

		awful.key({ Win, Shi }, "#"..i+9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tag"}),

		awful.key({ Win, Alt }, "#"..i+9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

root.keys(globalkeys)

--------------------------------------- Enable dropterms key bindings ---------------------------------------
dropdown.onoff()

--------------------------------------- Client key bindings ---------------------------------------
clientkeys = gears.table.join(
		awful.key({ Alt      }, "F4",     function (c) c:kill() end),
		awful.key({ Win      }, "p",      function (c) c.sticky = not c.sticky end),
		awful.key({ Win,     }, "f",      function (c) c.fullscreen = not c.fullscreen end),
		awful.key({ Win, Alt }, "space",  awful.client.floating.toggle ),
		awful.key({ Win, Ctr }, "Return", function (c) c:swap(awful.client.getmaster()) end),
		awful.key({ Win,     }, "o",      function (c) c:move_to_screen() end),
		awful.key({ Win, Alt }, "r",      function (c) c:redraw() end),
		awful.key({ Win,     }, "t",      function (c) c.ontop = not c.ontop end),
		awful.key({ Win,     }, "n",      function (c) c.minimized = not c.minimized end),
		awful.key({ Win, Shi }, "Right",  shift_to_tag(1)),
		awful.key({ Win, Shi }, "Left",   shift_to_tag(-1)),
		awful.key({ Win,     }, "i",      client_info),
		awful.key({ Win, Alt }, "KP_Add", function (c) if c.opacity < 0.9 then c.opacity = c.opacity + 0.1 else c.opacity = 1 end end),
		awful.key({ Win, Alt }, "KP_Subtract", function (c) if c.opacity > 0.1 then c.opacity = c.opacity - 0.1 else c.opacity = 0.1 end end),
		awful.key({ Win,     }, "m",	  function (c)
							c.maximized   = not c.maximized
						  end)
)

--------------------------------------- Client mouse actions ---------------------------------------
clientbuttons = gears.table.join(
		awful.button({     }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ Win }, 1, awful.mouse.client.move),
		awful.button({ Win }, 2, function (c) c:kill() end),
		awful.button({ Win }, 3, awful.mouse.client.resize),
		awful.button({ Win }, 4, function(c) awful.tag.viewnext(mouse.screen) end),
		awful.button({ Win }, 5, function(c) awful.tag.viewprev(mouse.screen) end))

-- vim:ts=4:sw=4
