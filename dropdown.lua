local drop = {
	enabled = false,
	startup = true,
}

function drop.onoff()

	local globalkeys = root.keys()

	hasitem = gears.table.hasitem

	if drop.enabled then
		rout("Drop terminals Off", 1)
		globalkeys = filter_table(globalkeys, function(x)
			return (x.key == "F1" or x.key == "F2")
				   and not hasitem(x.modifiers, Win)
		end)
	else
		rout("Drop terminals On", 1)
		globalkeys = gears.table.join(globalkeys,
			awful.key({     }, "F1", function () drop.toggle(1) end ),
			awful.key({     }, "F2", function () drop.toggle(2) end ))
	end

	drop.enabled = not drop.enabled
	root.keys(globalkeys)
end

function drop.setprop(c, n, resize)
	area = awful.screen.focused().geometry
	yy = area.y
	xx = area.x + (area.width - c:geometry().width)/2
	ww = 800
	hh = 300

	if n == 2 then
		yy = yy + area.height - c:geometry().height - 2

	elseif n == 3 then
		xx = area.x
		ww = area.width / 2
		hh = area.height - 2
	end

	if resize then
		c:geometry({ width = ww, height = hh, y = yy, x = xx})
	else
		c:geometry({ y = yy, x = xx})
	end

	-- Only hide if it already exists when awesome just started
	c.hidden = drop.startup
end

function drop.toggle(n)
	drop.startup = false
	local c = getclient("instance", "dropterm"..n)
	if not c then
		if n == 3 then
			awful.spawn(terminal.." -name dropterm"..n.." -e su")
		else
			awful.spawn(terminal.." -name dropterm"..n)
		end
	elseif c.hidden then
		drop.setprop(c, n, false)
		client.focus = c
		c:raise()
	else
		if c ~= client.focus then
			client.focus = c
		else
			c.hidden = true
		end
	end
end

return drop

-- vim:ts=4:sw=4
