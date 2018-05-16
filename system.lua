system = {
	widget = wibox.widget.textbox(),
	path_temp = "/sys/class/thermal/thermal_zone0/temp",
	icon_temp = "&#xf2cb;",  -- fa-thermometer-empty
}

local function status()

	local ftemp = io.open(system.path_temp)

	local temp = ftemp:read("*number") / 1000
	ftemp:close()

	local color = beautiful.fg_focus
	local text =  string.format(
		"<span font='fontawesome'>%s</span> <span color='%s'>%d ºC</span>",
		system.icon_temp, color, temp)

	return text

end

-- Update level textbox
function system.reload()
	if not system.widget then
		return
	end
	system.widget.markup = status()
end

-- Show infromation popup
local function info()
	-- TODO
end

-- Setup widget
local function init()

	if not awful.util.file_readable(system.path_temp) then
		system.widget = nil
		return nil
	end

	system.widget:buttons(gears.table.join(
		awful.button({ }, 1, function() info() end),
		awful.button({ }, 3, function() system.reload() end)
	))

	system.reload()

end

return system

-- vim:ts=4:sw=4
