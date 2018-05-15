local async = awful.spawn.easy_async

mpd = {
	widget = wibox.widget.textbox(),
}

function mpd.present()
	return program_exists("mpc")
end

-- Update the textbox with the current mpd level
local function update(cmd, popup, t)
	async("mpc "..cmd, function(output)

		local state = output:match("\n%[(%a+)%]")
		local symbol

		if not state then
			symbol = "&#xf04d;" -- fa-stop
		elseif state == "playing" then
			symbol = "&#xf04b;" -- fa-play
		elseif state == "paused" then
			symbol = "&#xf04c;" -- fa-pause
		else
			symbol = "&#xf04d;" -- fa-stop
		end

		mpd.widget.markup = string.format(
			"<span font=\"fontawesome 7\" color=\"%s\" rise=\"5\">%s</span>",
			beautiful.fg_focus, symbol)

		if popup then
			rout(output, t)
		end
	end)

end

local function cmd(s, t)
	if not t then t = 2 end
	return function()
		update(s, true, t)
	end
end

-- Toggle mpd client
local function client()
	local c = getclient("name", "ncmpc")
	if not c then
		awful.spawn(terminal.." -geometry 80x58-+0+21 -e ncmpc")
		update("", false)
	else
		--c:kill()
		awful.spawn("pkill -9 ncmpc")
		update("", false)
	end

end

-- Setup widget
local function init()

	if not mpd.present() then
		return
	end

	mpd.toggle = cmd("toggle")
	mpd.next = cmd("next")
	mpd.prev = cmd("prev")
	mpd.show = cmd("", 0)
	mpd.stop = function() update("stop") end

	mpd.widget:buttons(gears.table.join(
		awful.button({ }, 1, mpd.toggle),
		awful.button({ }, 2, mpd.stop),
		awful.button({ }, 3, client),
		awful.button({ }, 4, mpd.prev),
		awful.button({ }, 5, mpd.next)
	))

	update("", false)
	return mpd.widget
end

init()
return mpd

-- vim:ts=4:sw=4
