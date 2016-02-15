conky = {
	widget = wibox.widget.textbox(),

	spawn = function()
		local c = getclient("instance", "Conky")

		if not c then
			spawn("conky")

		elseif c.screen == mouse.screen then
			c:kill()
			return
		else
			c:geometry({x = 0})
			awful.client.movetoscreen(c, mouse.screen)
		end
	end,

	toggle_screen = function(c)

		c:geometry({x = 0})
		if mouse.screen == 1 then
			awful.client.movetoscreen(c, 2)
		else
			awful.client.movetoscreen(c, 1)
		end
		awful.screen.focus_relative(1)

	end,

	callback = function(c)
		local strutwidth = 200
		c:struts( { left = strutwidth } )
		c:buttons(awful.util.table.join(
			awful.button({     }, 4, function(c) awful.tag.viewnext(mouse.screen) end),
			awful.button({     }, 5, function(c) awful.tag.viewprev(mouse.screen) end),
			awful.button({     }, 3, function (c) conky.toggle_screen(c) end),
			awful.button({ Win }, 2, function (c) c:kill() end)
		))

	end,

	-- Setup widget
	init = function()

		-- Binds
		conky.widget:buttons(awful.util.table.join(awful.button({ }, 1, conky.spawn)))

		-- Start
		conky.widget:set_text("#")

		return conky.widget
	end,
}


