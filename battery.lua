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

function battery.read(file)

	local fd = io.open(battery.path .. file)
	if not fd then
		return 0
	end

	local value = fd:read("*number")
	fd:close()
	return value
end

local function status()

	local fstate = io.open(battery.path.."status")

	if fstate then
		local state = fstate:read("*all")
		fstate:close()

		local capacity    = battery.read("capacity")
		local voltage_now = battery.read("voltage_now") / 1000000

		local energy_now  = battery.read("energy_now") / 1000
		local energy_full = battery.read("energy_full") / 1000

		local charge_now  = battery.read("charge_now") / 1000
		local charge_full = battery.read("charge_full") / 1000

		local power_now   = battery.read("power_now") / 1000
		local current_now = battery.read("current_now") / 1000

		if energy_now == 0 then
			energy_now = charge_now * voltage_now
		end

		if energy_full == 0 then
			energy_full = charge_full * voltage_now
		end

		if  power_now == 0 then
			power_now = current_now * voltage_now
		end

		local time_left = energy_now / power_now
		local hours_left = math.floor(time_left)
		local minutes_left = math.floor((time_left - hours_left) * 60)
		local power_s = string.format("%.2f", (power_now / 1000))

		local color_text = beautiful.fg_focus
		local color_icon = beautiful.fg_normal

		local icon = battery.icons[1]

		if state == "Full\n" then
			return string.format(
			"<span color='%s' font='fontawesome'>%s</span> <span color='%s'>%s</span>",
			color_icon, battery.icons[5], color_text, "Battery full")

		elseif state == "Discharging\n" then

			if capacity < 20 then
				color_text = beautiful.bg_urgent
			end

			icon = battery.icons[math.ceil(capacity/20)]
		else
			icon = battery.icons[6] -- Plug icon
		end

		local text = string.format(
			"<span color='%s' font='fontawesome'>%s</span> <span color='%s'>%d%% </span>/<span color='%s'> %s W</span>",
			color_icon, icon, color_text, capacity, color_text, power_s)


		if state == "Discharging\n" then

			text = string.format("%s / <span color='%s'>%dh%dm</span>",
				text, color_text, hours_left, minutes_left)

			if capacity < 5 then
				urgent("WARNING!", "Battery low")
			elseif capacity < 10 then
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
