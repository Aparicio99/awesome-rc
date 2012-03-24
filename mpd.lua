mpd = {
	widget = widget({ type = "textbox" }),

	-- Update the textbox with the current mpd level
	update = function(cmd)
		output = pread("mpc "..cmd)

		local state = output:match("\n%[(%a+)%]")

		if state == "playing" then
			mpd.widget.text = " <span color=\"green\">▶</span> "
		elseif state == "paused" then
			mpd.widget.text = " || "
		else
			mpd.widget.text = " ◼ "
		end

		return output
	end,

	cmd = function(s, t)
		if not t then t = 2 end
		return function()
			rout(mpd.update(s), t)
		end
	end,

	-- Toggle mpd client
	client = function()
		local c = getclient("name", "ncmpc")
		if not c then
			spawn(terminal.." -g 80x58--3+20 -e ncmpc")
			mpd.update("")
		else
			--c:kill()
			spawn("pkill -9 ncmpc")
			mpd.update("")
		end

	end,

	-- Setup widget
	init = function()

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

		mpd.update("")
		return mpd.widget
	end,
}
