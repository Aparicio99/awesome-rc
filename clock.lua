clock = {
	offset = 0,
	format = " %a %b %d %H:%M ",
	long = false,
	widget = widget({type = "textbox"}),
	timer = timer({timeout = 60}),
	supertimer = timer({timeout = 1}),

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
			longformat = " %d/%m/%y %H:%M:%S "
		else
			longformat = " %s "
		end

		if clock.long then
			clock.supertimer:stop()
			clock.widget.text = os.date(clock.format)
			clock.timer:start()
		else
			clock.timer:stop()
			clock.widget.text = os.date(longformat)
			clock.supertimer:start()
		end
		clock.long = not clock.long
	end,

	-- Setup widget
	init = function()
		-- Timers
		clock.timer:add_signal("timeout", function()
							clock.widget.text = os.date(clock.format)
							battery.reload()
						end)
		clock.supertimer:add_signal("timeout", function() clock.widget.text = os.date(longformat) end)

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
		clock.widget.text = os.date(clock.format)
		clock.timer:start()

		return clock.widget
	end,
}


