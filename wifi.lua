wifi = {
	widget = wibox.widget.textbox(),
	wifi_interface = "",

	status = function()
		local output = pread("/usr/sbin/iw wlo1 link")

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

		return text
	end,


	-- Update textbox
	reload = function()
		if wifi.widget == nil then
			return
		end
		wifi.widget:set_markup(wifi.status())
	end,

	-- Show infromation popup
	info = function()
	end,

	-- Setup widget
	init = function()

		wifi.widget:buttons(awful.util.table.join(
			awful.button({ }, 1, function() wifi.info() end),
			awful.button({ }, 3, function() wifi.reload() end)
		))

		wifi.reload()

		return wifi.widget
	end,
}
