clock = {
	widget = widget({type = "textbox"}),
	timer_min = timer({timeout = 60}),
	timer_sec = timer({timeout = 1}),
	offset = 0,
	long = false,
	format_min = " %a %b %d <span color=\"green\">%H:%M</span>  ",
	format_sec = " %d/%m/%y <span color=\"red\">%H:%M:%S</span>",
	format_nix = "      %s   ",
	format2 = format_sec,

	-- Show calendar popup
	showcalendar = function(offset)
		if offset ~= 0 then
			offset = clock.offset + offset
		end
		clock.offset = offset

		local datespec = os.date("*t")
		local date = datespec.year * 12 + datespec.month - 1 + offset
		date = (date % 12 + 1) .. " " .. math.floor(date / 12)

		local cal = pread("cal " .. date)
		cal = string.gsub(cal, "^(%s*%S* %S*%s*)\n", "<b><span color=\"white\">%1</span></b>\n")

		local day = datespec.day

		if offset == 0 then
			cal = string.gsub(cal, "([\n ])(" .. day .. ")([\n ])", "%1<b><span color='white'>%2</span></b>%3")
		end

		naughty.notify({text = cal, timeout = 0, replaces_id = 1})
	end,

	-- Show weather popup
	showweather = function()
		local t = pread("/home/aparicio/scripts/meteo")
		local file = nil

		local s, e = string.find(t, '%S*.gif')
		if s ~= nil then
			file = config.."/meteo/"..string.sub(t, s, e)
			t = t:gsub("%S*.gif\n", "")
		end

		naughty.notify({text = t, timeout = 0, replaces_id = 1, icon = file})
	end,

	-- Toggle hour format
	toggle = function(n)
		if n == 1 then
			clock.format2 = clock.format_sec
		else
			clock.format2 = clock.format_nix
		end

		if clock.long then
			clock.timer_sec:stop()
			clock.widget.text = os.date(clock.format_min)
			clock.timer_min:start()
		else
			clock.timer_min:stop()
			clock.widget.text = os.date(clock.format2)
			clock.timer_sec:start()
		end
		clock.long = not clock.long
	end,

	-- Setup widget
	init = function()
		-- Timers
		clock.timer_min:add_signal("timeout", function()
							clock.widget.text = os.date(clock.format_min)
							battery.reload()
						end)
		clock.timer_sec:add_signal("timeout", function() clock.widget.text = os.date(clock.format2) end)

		-- Binds
		clock.widget:buttons(awful.util.table.join(
			awful.button({ }, 1, function() clock.showcalendar(0) end),
			awful.button({ }, 2, function() clock.toggle(2) end),
			awful.button({ }, 3, function() clock.toggle(1) end),
			awful.button({ }, 4, function() clock.showcalendar(-1) end),
			awful.button({ }, 5, function() clock.showcalendar(1) end),
			awful.button({ Win }, 1, function() spawn_out("cal -3", 0) end),
			awful.button({ Win }, 2, function() clock.showweather() end),
			awful.button({ Win }, 3, function() spawn_out("cal -y", 0) end)
		))

		-- Start
		clock.widget.text = os.date(clock.format_min)
		clock.timer_min:start()

		return clock.widget
	end,
}


