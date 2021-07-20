local async = awful.spawn.easy_async

local volume = {
	widget = wibox.widget.textbox(),
	device = "Master",
	value = 0,
	default = 15, -- percent
	threshold = 5, -- percent
	reset = true,
	icons = {
		"&#xf026;", -- fa-volume-off
		"&#xf027;", -- fa-volume-down
		"&#xf028;"  -- fa-volume-up
	},
}

local function update_callback(output)

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

	volume.widget.markup = string.format(
		"<span font=\"fontawesome 7\">%s</span> <span color='%s'>%s</span>",
		icon, color_text, level)
end

-- Update the textbox with the current volume level
local function update(output)
	if not output then
		async("amixer get "..volume.device, update_callback)
	else
		update_callback(output)
	end

end

-- Toggle volume mute
function volume.toggle()
	async("amixer set Master toggle",
		function(output)
			local mute = output:match("%[%a+%]")

			if mute == "[on]" then
				rout("Mute OFF", 2)
			else
				rout("Mute ON", 2)
			end
			update(output)
		end)
end

-- Toggle volume reset
function volume.toggle_reset()
	volume.reset = not volume.reset
	if volume.reset then
		rout("Volume reset ON", 1)
	else
		rout("Volume reset OFF", 1)
	end
end

-- Set volume level
function volume.set(value)
	async(string.format("amixer set %s %s%%", volume.device, value),
		function (output) update(output) end)
end

function volume.inc()
	if volume.value < 100 then
		volume.set(volume.value + 1)
	end
end

function volume.dec()
	if volume.value > 0 then
		volume.set(volume.value - 1)
	end
end

-- Set volume to default if reset is enabled and exceeds threshold
function volume.check()

	if not volume.reset then
		return
	end

	if math.abs(volume.value - volume.default) > volume.threshold then
		volume.set(volume.default)
	end
end

function volume.set_default(value)
	volume.default = value
	rout(string.format("Default volume = %d +/- %d", volume.default, volume.threshold), 2)
end

function volume.copy_default()
	volume.set_default(volume.value)
end

function volume.inc_default()
	if volume.default < 100 then
		volume.set_default(volume.default + 1)
		volume.set(volume.default)
	end
end

function volume.dec_default()
	if volume.default > 0 then
		volume.set_default(volume.default - 1)
		volume.set(volume.default)
	end
end

-- Setup widget
local function init()

	async("amixer get PCM",
		function (output)
			if output ~= "" then
				volume.device = "PCM"
				update()
			else
				update(output)
			end
		end)

	volume.widget:buttons(gears.table.join(
		awful.button({     }, 1, volume.check),
		awful.button({     }, 2, volume.toggle),
		awful.button({     }, 3, volume.toggle_reset),
		awful.button({     }, 4, volume.inc),
		awful.button({     }, 5, volume.dec),
		awful.button({ Win }, 1, volume.copy_default),
		awful.button({ Win }, 4, volume.inc_default),
		awful.button({ Win }, 5, volume.dec_default)
	))
end

init()
return volume

-- vim:ts=4:sw=4
