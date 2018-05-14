conky = {
	widget = wibox.widget.textbox(),
}

local function spawn_here()
	local c = getclient("instance", "conky")

	if not c then
		awful.spawn("conky")

	elseif c.screen == mouse.screen then
		c:kill()
		return
	else
		--c:geometry({x = 0})
		awful.client.movetoscreen(c, mouse.screen)
	end
end

local function spawn_there()

	local c = getclient("instance", "conky")

	if not c then
		awful.spawn("conky")
	else
		--c:geometry({x = 0})
		if mouse.screen == 1 then
			awful.client.movetoscreen(c, 2)
		else
			awful.client.movetoscreen(c, 1)
		end
	end
end

function conky.callback(c)
	c:struts( { right = 200 } )
	c:buttons(gears.table.join(
		awful.button({     }, 4, function(c) awful.tag.viewnext(mouse.screen) end),
		awful.button({     }, 5, function(c) awful.tag.viewprev(mouse.screen) end),
		awful.button({ Win }, 2, function (c) c:kill() end)
	))
end

-- Setup widget
local function init()

	-- Binds
	conky.widget:buttons(gears.table.join(
		awful.button({ }, 1, spawn_here),
		awful.button({ }, 3, spawn_there)))

	conky.widget.text = " "

	return conky.widget
end

init()
return conky

-- vim:ts=4:sw=4
