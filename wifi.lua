local async = awful.spawn.easy_async

wifi = {
	widget = wibox.widget.textbox(),
	wifi_interface = "",

	reload = function()
		async("/usr/sbin/iw wlo1 link", function (output)

			local ssid = output:match("SSID: (%w+)")
			if not ssid then ssid = "-" end
			local signal = output:match("signal: (%-%d+)")
			if not signal then signal = "-" end
			local bitrate = output:match("bitrate: (%d+)")
			if not bitrate then bitrate = "-" end

			local color = beautiful.fg_focus
			local text =  "<span font=\"fontawesome\">&#xf1eb;</span> ".."<span color='"..color.."'>"..ssid.."</span>"
			text = text .." / <span color='"..color.."'>"..signal.." dBm</span>"
			text = text .." / <span color='"..color.."'>"..bitrate.." mbit/s</span>"

			wifi.set_status(text)
		end)
	end,


	-- Update textbox
	set_status = function(text)
		if wifi.widget == nil then
			return
		end
		wifi.widget.markup = text
	end,

	-- Show infromation popup
	info = function()
	end,

	-- Setup widget
	init = function()

		wifi.widget:buttons(gears.table.join(
			awful.button({ }, 1, function() wifi.info() end),
			awful.button({ }, 3, function() wifi.reload() end)
		))

		wifi.reload()

		return wifi.widget
	end,
}

-- vim:ts=4:sw=4