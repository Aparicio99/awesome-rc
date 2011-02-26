volume = {
	reset = true,
	widget = widget({ type = "textbox" }),

	-- Update the textbox with the current volume level
	update = function(output)
		if not output then
			output = pread("amixer get Master")
		end

		local level = output:match("%d+%%")
		local mute = output:match("%[%a+%]")

		if mute == "[on]" then
			volume.widget.text = " Vol "..level
		else
			volume.widget.text = " Vol "..level.." Muted"
		end
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
	end,

	-- Set volume level
	set = function(s)
		volume.update(pread("amixer set Master "..s))
	end,

	inc = function() volume.set("1+") end,
	dec = function() volume.set("1-") end,

	-- Set volume to 50% if reset is enabled
	check = function()
		if volume.reset then
			volume.set("50%")
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
