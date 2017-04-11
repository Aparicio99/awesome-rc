conky = {
	widget = wibox.widget.textbox(),

	spawn_here = function()
		local c = getclient("instance", "conky")

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

	spawn_there = function()

		local c = getclient("instance", "conky")

		if not c then
			spawn("conky")
		else
			c:geometry({x = 0})
			if mouse.screen == 1 then
				awful.client.movetoscreen(c, 2)
			else
				awful.client.movetoscreen(c, 1)
			end
		end
	end,

	callback = function(c)
		local strutwidth = 200
		c:struts( { left = strutwidth } )
		c:buttons(awful.util.table.join(
			awful.button({     }, 4, function(c) awful.tag.viewnext(mouse.screen) end),
			awful.button({     }, 5, function(c) awful.tag.viewprev(mouse.screen) end),
			awful.button({ Win }, 2, function (c) c:kill() end)
		))

	end,

	-- Setup widget
	init = function()

		-- Binds
		conky.widget:buttons(awful.util.table.join(
		                              awful.button({ }, 1, conky.spawn_here),
		                              awful.button({ }, 3, conky.spawn_there)))

		-- Start
		conky.widget:set_text(" ")

		return conky.widget
	end,
}


