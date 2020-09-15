local async = awful.spawn.easy_async

music = {
	widget = wibox.widget.textbox(),
}

function music.present()
	return program_exists("music")
end

-- Update the textbox with the current music level
local function update(cmd, popup, t)
	async("music "..cmd, function(output)

		local symbol

		if not output then
			symbol = "&#xf04d;" -- fa-stop
		elseif string.find(output, "playing") then
			symbol = "&#xf04b;" -- fa-play
		elseif string.find(output, "paused") then
			symbol = "&#xf04c;" -- fa-pause
		else
			symbol = "&#xf04d;" -- fa-stop
		end

		music.widget.markup = string.format(
			"<span font=\"fontawesome 7\" color=\"%s\" rise=\"5\">%s</span>",
			beautiful.fg_focus, symbol)
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

	if not music.present() then
		return
	end

	music.toggle = cmd("toggle")
	music.next = cmd("next")
	music.prev = cmd("prev")
	music.show = cmd("", 0)
	music.stop = function() update("stop") end

	music.widget:buttons(gears.table.join(
		awful.button({ }, 1, music.toggle),
		awful.button({ }, 2, music.stop),
		awful.button({ }, 3, client),
		awful.button({ }, 4, music.prev),
		awful.button({ }, 5, music.next)
	))

	update("", false)
	return music.widget
end

init()
return music

-- vim:ts=4:sw=4
