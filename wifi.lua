local async = awful.spawn.easy_async

local wifi = {
	widget = wibox.widget.textbox(),
	interface = "",
}

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

function reload()
	async("iw "..wifi.interface.." link", function (output)

		local ssid = output:match("SSID: ([%w%p]+)")
		if not ssid then ssid = "-" end
		local signal = output:match("signal: (%-%d+)")
		if not signal then signal = "-" end
		local bitrate = output:match("bitrate: (%d+)")
		if not bitrate then bitrate = "-" end

		local color = beautiful.fg_focus
		--local text =  "<span font=\"fontawesome\">&#xf1eb;</span> ".."<span color='"..color.."'>"..ssid.."</span>"
		local text =  "<span color='"..color.."'>"..ssid.."</span>"
		text = text .." / <span color='"..color.."'>"..signal.." dBm</span>"
		text = text .." / <span color='"..color.."'>"..bitrate.." mbit/s</span>"

		set_status(text)
	end)
end

-- Setup widget
local function init()

	async("iw dev", function (output)

		local interface = output:match("Interface (%w+)")

		if not interface then
			wifi.widget = nil
			return
		end

		wifi.interface = interface

		wifi.widget:buttons(gears.table.join(
			awful.button({ }, 1, function() info() end),
			awful.button({ }, 3, function() reload() end)
		))
		reload()
	end)
end

init()
return wifi

-- vim:ts=4:sw=4
