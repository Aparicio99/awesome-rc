local async = awful.spawn.easy_async

local wifi = {
	widget = wibox.widget.textbox(),
	wifi_interface = "",
}

function reload()
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

		set_status(text)
	end)
end


-- Update textbox
local function set_status(text)
	if wifi.widget == nil then
		return
	end
	wifi.widget.markup = text
end

-- Show infromation popup
local function info()
	-- TODO
end

-- Setup widget
local function init()

	wifi.widget:buttons(gears.table.join(
		awful.button({ }, 1, function() info() end),
		awful.button({ }, 3, function() reload() end)
	))

	reload()
end

init()
return wifi

-- vim:ts=4:sw=4
