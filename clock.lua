local timer = gears.timer
local async = awful.spawn.easy_async

clock = {
	widget = wibox.widget.textbox(),
	timer_min = timer({timeout = 5}),
	timer_sec = timer({timeout = 1}),
	offset = 0,
	long = false,
	format_min = "%a %b %d <span color=\"" .. beautiful.fg_focus .. "\">%H:%M</span>",
	format_sec = "%d/%m/%y <span color=\"#ff0000\">%H:%M:%S</span>",
	format_nix = "<span color=\"#ff0000\">%s</span>",
	format2 = format_sec,
}

-- Show calendar popup
function clock.showcalendar(offset)
	if offset ~= 0 then
		offset = clock.offset + offset
	end
	clock.offset = offset

	local datespec = os.date("*t")
	local date = datespec.year * 12 + datespec.month - 1 + offset
	date = (date % 12 + 1) .. " " .. math.floor(date / 12)

	spawn_out("cal")

	async("cal " .. date,
		function(output)
			local cal = string.gsub(cal, "^(%s*%S* %S*%s*)\n", "<b><span color=\"white\">%1</span></b>\n")

			local day = datespec.day

			if offset == 0 then
				cal = string.gsub(cal, "([\n ])(" .. day .. ")([\n ])", "%1<b><span color='" .. beautiful.fg_focus .. "'>%2</span></b>%3")
			end

			naughty.notify({text = cal, timeout = 0, replaces_id = 1})
		end)
end

-- Toggle hour format
function clock.toggle(n)
	if n == 1 then
		clock.format2 = clock.format_sec
	else
		clock.format2 = clock.format_nix
	end

	if clock.long then
		clock.timer_sec:stop()
		clock.widget.markup = os.date(clock.format_min)
		clock.timer_min:start()
	else
		clock.timer_min:stop()
		clock.widget.markup = os.date(clock.format2)
		clock.timer_sec:start()
	end
	clock.long = not clock.long
end

-- Setup widget
local function init()
	-- Timers
	clock.timer_min:connect_signal("timeout", function()
						clock.widget.markup = os.date(clock.format_min)
						if battery.present() then
							battery.reload()
							wifi.reload()
							system.reload()
						end
					end)
	clock.timer_sec:connect_signal("timeout", function() clock.widget.markup = os.date(clock.format2) end)

	-- Binds
	clock.widget:buttons(gears.table.join(
		awful.button({ }, 1, function() clock.showcalendar(0) end),
		awful.button({ }, 2, function() clock.toggle(2) end),
		awful.button({ }, 3, function() clock.toggle(1) end),
		awful.button({ }, 4, function() clock.showcalendar(-1) end),
		awful.button({ }, 5, function() clock.showcalendar(1) end),
		awful.button({ Win }, 1, function() spawn_out("cal -3", 0) end),
		awful.button({ Win }, 3, function() spawn_out("cal -y", 0) end)
	))

	-- Start
	clock.widget.markup = os.date(clock.format_min)
	clock.timer_min:start()

	return clock.widget
end

init()
return clock

-- vim:ts=4:sw=4
