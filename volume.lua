local gears = require("gears")

volume = {
	widget = wibox.widget.textbox(),
	device = "Master",
	value = 0,
	default = "10%",
	reset = true,
	icons = {
		"&#xf026;", -- fa-volume-off
		"&#xf027;", -- fa-volume-down
		"&#xf028;"  -- fa-volume-up
	},

	update_callback = function(output)

		local level = output:match("%d+%%")
		local mute = output:match("%[%a+%]")
		volume.value = tonumber(level:sub(0,-2))

		if volume.value < 10 then
			icon = volume.icons[1]
		elseif volume.value < 50 then
			icon = volume.icons[2]
		else
			icon = volume.icons[3]
		end

		local color_text = beautiful.fg_focus

		if mute == "[off]" then
			color_text = beautiful.bg_urgent
		end

		local text = string.format(
			"<span font='fontawesome'>%s</span> <span color='%s'>%s</span>",
			icon, color_text, level)

		volume.widget.markup = text
	end,

	-- Update the textbox with the current volume level
	update = function(output)
		if not output then
			async("amixer get "..volume.device, update_callback)
		else
			update_callback(output)
		end

	end,

	-- Toggle volume mute
	toggle = function()
		async("amixer set Master toggle",
			function(output)
				local mute = output:match("%[%a+%]")

				if mute == "[on]" then
					rout("Mute OFF", 2)
				else
					rout("Mute ON", 2)
				end
				volume.update(output)
			end)
	end,

	-- Toggle volume reset
	toggle_reset = function()
		volume.reset = not volume.reset
		if volume.reset then
			rout("Volume reset ON", 1)
		else
			rout("Volume reset OFF", 1)
		end
		--volume.update(
	end,

	-- Set volume level
	set = function(s)
		async("amixer set "..volume.device.." "..s,
			function (output) volume.update(output) end)
	end,

	inc = function() volume.set("1%+") end,
	dec = function() volume.set("1%-") end,

	-- Set volume to 50% if reset is enabled
	check = function()
		if volume.reset then
			if volume.value < 5 or volume.value > 20 then
				volume.set(volume.default)
			end
		else
			volume.set("100%")
		end
	end,

	-- Setup widget
	init = function()

		async("amixer get PCM",
			function (output)
				if output ~= "" then
					volume.device = "PCM"
				end
			end)

		volume.update()

		volume.widget:buttons(gears.table.join(
			awful.button({ }, 1, volume.check),
			awful.button({ }, 2, volume.toggle),
			awful.button({ }, 3, volume.toggle_reset),
			awful.button({ }, 4, volume.inc),
			awful.button({ }, 5, volume.dec)
		))

		return volume.widget
	end,
}

-- vim:ts=4:sw=4
