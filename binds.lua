
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
		awful.key({     }, "Pause",                sleep),
		awful.key({     }, "Scroll_Lock",          lspawn("/home/aparicio/scripts/scroll_led off")),
		awful.key({     }, "XF86AudioMute",        volume.toggle),
		awful.key({     }, "XF86AudioRaiseVolume", volume.inc),
		awful.key({     }, "XF86AudioLowerVolume", volume.dec),
		awful.key({ Win }, "+",                    volume.inc),
		awful.key({ Win }, "-",                    volume.dec),
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
		--awful.key({ Alt }, "F2",		   dmenu),
		awful.key({     }, "F4",                   function () toggle_hidden("instance", "skype", "Pidgin") spawn("/home/aparicio/scripts/scroll_led off") end),
		awful.key({ Win }, "s",                    clipboard.seltocli),
		awful.key({ Win }, "c",                    clipboard.clitosel),

		-- Prompts
		awful.key({ Win }, "r",	function () promptbox[mouse.screen]:run() end ),
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
		awful.key({ Win, Alt }, "KP_Add", function (c) if c.opacity < 0.9 then c.opacity = c.opacity + 0.1 else c.opacity = 1 end end),
		awful.key({ Win, Alt }, "KP_Subtract", function (c) if c.opacity > 0.1 then c.opacity = c.opacity - 0.1 else c.opacity = 0.1 end end),
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
