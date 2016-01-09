volume = {
	reset = true,
	value = 0,
	default = "10%",
	widget = wibox.widget.textbox(),

	-- Update the textbox with the current volume level
	update = function(output)
		if not output then
			output = pread("amixer get PCM")
		end

		local level = output:match("%d+%%")
		local mute = output:match("%[%a+%]")

		local text = "Vol <span color=\"" .. beautiful.fg_focus .. "\">"..level.."</span>"

		if mute == "[off]" then
			text = "Vol "..level
		end

		--if not volume.reset then
		--	text = "<span color='orange'>"..text.."</span>"
		--end

		volume.widget:set_markup(text)
		volume.value = tonumber(level:sub(0,-2))
	end,

	-- Toggle volume mute
	toggle = function()
		local output = pread("amixer set Master toggle")
		local mute = output:match("%[%a+%]")

		if mute == "[on]" then
			rout("Mute OFF", 2)
		else
			rout("Mute ON", 2)
		end
		volume.update(output)
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
		volume.update(pread("amixer set PCM "..s))
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
		volume.widget:buttons(awful.util.table.join(
			awful.button({ }, 1, volume.check),
			awful.button({ }, 2, volume.toggle),
			awful.button({ }, 3, volume.toggle_reset),
			awful.button({ }, 4, volume.inc),
			awful.button({ }, 5, volume.dec)
		))

		volume.update()
		return volume.widget
	end,
}
