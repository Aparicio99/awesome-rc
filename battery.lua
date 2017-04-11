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
			local fstate = io.open(battery.path.."status")

			local chargenow = fchargenow:read("*number")
			local chargefull = fchargefull:read("*number")
			local current = fcurrent:read("*number")
			local state = fstate:read("*all")

			fchargenow:close()
			fchargefull:close()
			fcurrent:close()
			fstate:close()

			local value = math.floor(chargenow/chargefull * 100 + 0.5)
			local time_left = chargenow/current
			local hours_left = math.floor(time_left)
			local minutes_left = math.floor((time_left - hours_left) * 60)

			local color = beautiful.fg_focus
			if value < 20 then
				color = "red"
			elseif value < 50 then
				color = "orange"
			end

			local text = "Bat <span color='"..color.."'>"..value.."%</span>"

			if state == "Discharging\n" then

				text = text.." Time left <span color='"..color.."'>"..hours_left.."h"..minutes_left.."m</span>"

				if value < 10 then
					urgent("WARNING!", "Battery low")
				elseif value < 20 then
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
