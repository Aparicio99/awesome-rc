local battery = {
	widget = wibox.widget.textbox(),
	path1 = "/sys/class/power_supply/BAT0/",
	path2 = "/sys/class/power_supply/BAT1/",
	path = nil,
	icons = {
		"&#xf244;", -- fa-battery-empty
		"&#xf243;", -- fa-battery-quarter
		"&#xf242;", -- fa-battery-half
		"&#xf241;", -- fa-battery-three-quarters
		"&#xf240;", -- fa-battery-full
		"&#xf1e6;"  -- fa-plug
	},
}

local function status()

	local fstatus = io.open(battery.path.."status")

	if fstatus then
		local status = fstatus:read("*all")
		fstatus:close()

		local fchargenow  = io.open(battery.path.."energy_now")
		local fchargefull = io.open(battery.path.."energy_full")
		local fvoltage    = io.open(battery.path.."voltage_now")
		local fstate      = io.open(battery.path.."status")
		local fcurrent    = io.open(battery.path.."current_now")
		local fpower      = io.open(battery.path.."power_now")

		local chargenow = fchargenow:read("*number") / 1000
		local chargefull = fchargefull:read("*number") / 1000
		local voltage = fvoltage:read("*number") / 1000000
		local state = fstate:read("*all")

		local power = 0
		if fpower then
			power = fpower:read("*number") / 1000
		elseif fcurrent then
			local current = fcurrent:read("*number") / 1000
			power = current * voltage
		end

		fchargenow:close()
		fchargefull:close()
		fvoltage:close()
		fstate:close()
		if fcurrent then fcurrent:close() end
		if fpower then fpower:close() end

		local perc = math.floor(chargenow/chargefull * 100 + 0.5)
		local time_left = chargenow/power
		local hours_left = math.floor(time_left)
		local minutes_left = math.floor((time_left - hours_left) * 60)
		local power_s = string.format("%.2f", (power / 1000))

		local color_text = beautiful.fg_focus
		local color_icon = beautiful.fg_normal

		local icon = battery.icons[1]


		if status == "Full\n" then
			return string.format(
			"<span color='%s' font='fontawesome'>%s</span> <span color='%s'>%s</span>",
			color_icon, battery.icons[5], color_text, "Battery full")
		end

		if state == "Discharging\n" then

			if perc < 20 then
				color_text = beautiful.bg_urgent
			end

			icon = battery.icons[math.ceil(perc/20)]
		else
			icon = battery.icons[6] -- Plug icon
		end

		local text = string.format(
			"<span color='%s' font='fontawesome'>%s</span> <span color='%s'>%d%% </span>/<span color='%s'> %s W</span>",
			color_icon, icon, color_text, perc, color_text, power_s)


		if state == "Discharging\n" then

			text = string.format("%s / <span color='%s'>%dh%dm</span>",
				text, color_text, hours_left, minutes_left)

			if perc < 5 then
				urgent("WARNING!", "Battery low")
			elseif perc < 10 then
				out("Battery low")
			end
		else
			text = string.format("%s / <span color='%s'>charging</span>",
				text, color_text)
		end

		return text
	else
		return "Battery offline"
	end
end

-- Show infromation popup
local function info()
	if not battery.present() then
		return
	end

	local file = io.open(battery.path.."uevent")
	rout(file:read("*all"))
	file:close()
end

-- Setup widget
local function init()

	-- TODO: Rewrite this more flexible and clean
	if gears.filesystem.dir_readable(battery.path1) then
		battery.path = battery.path1
	end

	if gears.filesystem.dir_readable(battery.path2) then
		battery.path = battery.path2
	end

	if not battery.path then
		battery.widget = nil
		return nil
	end

	battery.widget:buttons(awful.util.table.join(
		awful.button({ }, 1, function() info() end),
		awful.button({ }, 3, function() battery.reload() end)
	))

	battery.reload()
end

function battery.present()
	return battery.widget ~= nil
end

-- Update level textbox
function battery.reload()
	if not battery.present() then
		return
	end
	battery.widget.markup = status()
end

init()
return battery

-- vim:ts=4:sw=4
