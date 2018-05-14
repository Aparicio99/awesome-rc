mpd = {
	widget = wibox.widget.textbox(),

	present = function()
		return program_exists("mpc")
	end,

	-- Update the textbox with the current mpd level
	update = function(cmd, popup, t)
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

	end,

	cmd = function(s, t)
		if not t then t = 2 end
		return function()
			mpd.update(s, true, t)
		end
	end,

	-- Toggle mpd client
	client = function()
		local c = getclient("name", "ncmpc")
		if not c then
			spawn(terminal.." -geometry 80x58-+2+19 -e ncmpc")
			mpd.update("", false)
		else
			--c:kill()
			spawn("pkill -9 ncmpc")
			mpd.update("", false)
		end

	end,

	-- Setup widget
	init = function()

		if not mpd.present() then
			return
		end

		mpd.toggle = mpd.cmd("toggle")
		mpd.next = mpd.cmd("next")
		mpd.prev = mpd.cmd("prev")
		mpd.show = mpd.cmd("", 0)
		mpd.stop = function() mpd.update("stop") end

		mpd.widget:buttons(awful.util.table.join(
			awful.button({ }, 1, mpd.toggle),
			awful.button({ }, 2, mpd.stop),
			awful.button({ }, 3, mpd.client),
			awful.button({ }, 4, mpd.prev),
			awful.button({ }, 5, mpd.next)
		))

		mpd.update("", false)
		return mpd.widget
	end,
}

-- vim:ts=4
