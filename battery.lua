battery = {
	path = "/sys/class/power_supply/BAT0/",
	widget = widget({type = "textbox"}),
	num = false,
	show = true,

	toggle = function()
		battery.widget.text = ""
		battery.show = not battery.show
		battery.reload()
	end,


	-- Update battery level textbox
	reload = function()
		if not battery.show then
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
			local fstate = io.open(battery.path.."status")

			local chargenow = fchargenow:read("*number")
			local chargefull = fchargefull:read("*number")
			local state = fstate:read("*all")

			fchargenow:close()
			fchargefull:close()
			fstate:close()

			local value = math.floor(chargenow/chargefull * 100 + 0.5)

			if battery.num then
				battery.widget.text = " Bat "..chargenow.."/"..chargefull.." "..value.."%"
			else
				local color = "#aaaaaa"
				if value < 20 then
					color = "red"
				elseif value < 50 then
					color = "orange"
				end

				local text = "<span color='"..color.."'>"..value.."%</span>"
				if state == "Discharging" then
					battery.widget.text = " Bat <b>"..text.."</b>"
				else
					battery.widget.text = " Bat "..text
				end
			end

			if state == "Discharging\n" then
				if value < 10 then
					urgent("WARNING!", "Battery low")
				elseif value < 20 then
					out("Battery low")
				end
			end

		else
			battery.widget.text = " Battery offline"
		end

		fstatus:close()
	end,

	-- Show battery infromation popup
	info = function()
		local file = io.open(battery.path.."uevent")
		rout(file:read("*all"))
		file:close()
	end,

	-- Setup widget
	init = function()

		battery.widget:buttons(awful.util.table.join(
						awful.button({ }, 1, function() battery.info() end),
						awful.button({ }, 2, function() battery.reload() end),
						awful.button({ }, 3, function() battery.num = not battery.num battery.reload() end)
		))

		battery.reload()

		return battery.widget
	end,
}
