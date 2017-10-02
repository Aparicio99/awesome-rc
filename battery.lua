battery = {
	path = "/sys/class/power_supply/BAT0/",
	widget = wibox.widget.textbox(),
	num = false,
	show = true,

	toggle = function()
		battery.widget:set_text("")
		battery.show = not battery.show
		battery.reload()
	end,


	-- Update battery level textbox
	reload = function()
		if not battery.show or battery.widget == nil then
			return
		end

		local fstatus = io.open(battery.path.."status")

		if fstatus then
			local status = fstatus:read("*all")

			if status == "Full\n" then
				battery.widget.text = ""
				return
			end

			local fchargenow = io.open(battery.path.."charge_now")
			local fchargefull = io.open(battery.path.."charge_full")
			local fcurrent = io.open(battery.path.."current_now")
			local fvoltage = io.open(battery.path.."voltage_now")
			local fstate = io.open(battery.path.."status")

			local chargenow = fchargenow:read("*number") / 1000
			local chargefull = fchargefull:read("*number") / 1000
			local current = fcurrent:read("*number") / 1000
			local voltage = fvoltage:read("*number") / 1000000
			local state = fstate:read("*all")

			fchargenow:close()
			fchargefull:close()
			fcurrent:close()
			fvoltage:close()
			fstate:close()

			local perc = math.floor(chargenow/chargefull * 100 + 0.5)
			local time_left = chargenow/current
			local hours_left = math.floor(time_left)
			local minutes_left = math.floor((time_left - hours_left) * 60)
			local power = string.format("%.2f", (current / 1000) * voltage)

			local color = beautiful.fg_focus
			if perc < 20 then
				color = "red"
			elseif perc < 50 then
				color = "orange"
			end

			local text = ""

			text = text.." <span color='"..color.."'>"..power.." W</span>"

			text = text.." Bat <span color='"..color.."'>"..perc.."%</span>"

			if state == "Discharging\n" then

				text = text.." Time left <span color='"..color.."'>"..hours_left.."h"..minutes_left.."m</span>"

				if perc < 10 then
					urgent("WARNING!", "Battery low")
				elseif perc < 20 then
					out("Battery low")
				end
			end

			battery.widget:set_markup(text)

		else
			battery.widget:set_markup("Battery offline")
		end

		fstatus:close()
	end,

	-- Show battery infromation popup
	info = function()
		if battery.widget == nil then
			return
		end
		local file = io.open(battery.path.."uevent")
		rout(file:read("*all"))
		file:close()
	end,

	-- Setup widget
	init = function()

		if not awful.util.file_readable(battery.path) then
			battery.widget = nil
			return nil
		end

		battery.widget:buttons(awful.util.table.join(
			awful.button({ }, 1, function() battery.info() end),
			awful.button({ }, 2, function() battery.reload() end),
			awful.button({ }, 3, function() battery.num = not battery.num battery.reload() end)
		))

		battery.reload()

		return battery.widget
	end,
}
