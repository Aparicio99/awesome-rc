system = {
	widget = wibox.widget.textbox(),
	path_temp = "/sys/class/thermal/thermal_zone0/temp",
	icon_temp = "&#xf2cb;",  -- fa-thermometer-empty

	status = function()

		local ftemp = io.open(system.path_temp)

		local temp = ftemp:read("*number") / 1000
		ftemp:close()

		local color = beautiful.fg_focus
		local text =  string.format(
			"<span font='fontawesome'>%s</span> <span color='%s'>%d ºC</span>",
			system.icon_temp, color, temp)

		return text

	end,

	-- Update level textbox
	reload = function()
		if not system.widget then
			return
		end
		system.widget.markup = system.status()
	end,

	-- Show infromation popup
	info = function()
	end,

	-- Setup widget
	init = function()

		if not awful.util.file_readable(system.path_temp) then
			system.widget = nil
			return nil
		end

		system.widget:buttons(gears.table.join(
			awful.button({ }, 1, function() system.info() end),
			awful.button({ }, 3, function() system.reload() end)
		))

		system.reload()

		return system.widget
	end,
}
