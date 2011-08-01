drop = {
	enable = true,

	onoff = function()
		if drop.enable then
			rout("Drop Off", 1)
			table.remove(globalkeys)
			table.remove(globalkeys)
			table.remove(globalkeys)
			table.remove(globalkeys)
			table.remove(globalkeys)
			table.remove(globalkeys)
			drop.enable = false
		else
			rout("Drop On", 1)
			globalkeys = awful.util.table.join(globalkeys,
				awful.key({     }, "F1", function () drop.toggle(1) end ),
				awful.key({     }, "F2", function () drop.toggle(2) end ))
			drop.enable = true
		end
		root.keys(globalkeys)
	end,

	setprop = function(c, n, resize)
		area = screen[mouse.screen].geometry
		yy = area.y
		xx = area.x + (area.width - c:geometry().width)/2
		ww = 800
		hh = 300

		if n == 2 then
			yy = yy + area.height - c:geometry().height

		elseif n == 3 then
			xx = area.x
			ww = area.width / 2
			hh = area.height
		end

		if resize then
			c:geometry({ width = ww, height = hh, y = yy, x = xx})
		else
			c:geometry({ y = yy, x = xx})
		end
		c.hidden = false
	end,

	manage = function(n)
		function func(c)
			drop.setprop(c, n, true)
			client.remove_signal("manage", func)
		end
		return func
	end,

	toggle = function(n)
		local c = getclient("instance", "dropterm"..n)
		if not c then
			client.add_signal("manage", drop.manage(n))
			if n == 3 then
				spawn(terminal.." -name dropterm"..n.." -e su")
			else
				spawn(terminal.." -name dropterm"..n)
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
	end,

}
