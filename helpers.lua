--------------------------------------- Helpers ---------------------------------------

function out(s, t)
	naughty.notify({ text=s, timeout=t })
end

function rout(s, t)
	naughty.notify({ text=s, timeout=t, replaces_id=0 })
end

function spawn_out(s, t)
	rout(pread(s), t)
end

function lspawn(s)
	return function()
		spawn(s)
	end
end

function urgent(s1, s2)
	naughty.notify({ title=s1, text=s2, bg="#ff0000", fg="#000000"})
end

function mkprompt(p, f, c)
	return function () awful.prompt.run({ prompt = p }, mypromptbox.widget, f, nil, c) end
end

function info()
	rout(	"Masters: " .. awful.tag.getnmaster() ..
		"\nColumns: " .. awful.tag.getncol() ..
		"\nFactor: " .. awful.tag.getmwfact())
end

function t(s)
	return terminal.." -e "..s
end

function dmenu()
	 spawn("dmenu_run -i -p 'Run:' -nb '" ..
		beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
		"' -sb '" .. beautiful.bg_focus ..
		"' -sf '" .. beautiful.fg_focus .. "'")
end

function shift_to_tag(n)
	return function(c)
		local id = awful.tag.getidx(awful.tag.selected(mouse.screen)) + n;

		if id > 4 then id = 1
		elseif id < 1 then id = 4 end

		local new = tags[c.screen][id]
		awful.client.movetotag(new)
		awful.tag.viewonly(new)
	end
end

function getclient(prop, val)
	for i, c in ipairs(client.get()) do
		if c[prop] == val then
			return c
		end
	end
end

function client_info()
  local v = ""

  -- object
  local c = client.focus
  v = v .. tostring(c)

  -- geometry
  local cc = c:geometry()
  local signx = cc.x >= 0 and "+"
  local signy = cc.y >= 0 and "+"
  v = v .. " @ " .. cc.width .. 'x' .. cc.height .. signx .. cc.x .. signy .. cc.y .. "\n\n"

  local inf = {
    "window", "name", "skip_taskbar", "type", "class", "instance", "pid", "role",
    "machine", "icon_name", "icon", "screen", "hidden", "minimized", "size_hints_honor",
    "border_width", "border_color", "titlebar", "urgent", "content", "focus", "opacity",
    "ontop", "above", "below", "fullscreen", "maximized_horizontal", "maximized_vertical",
    "transient_for", "group_window", "leader_id", "size_hints", "sticky", "modal", "focusable",
   }

  for i = 1, #inf do
    v =  v .. string.format("%2s: %-20s = %s\n", i, inf[i], tostring(c[inf[i]]))
  end

  naughty.notify{ text = v:sub(1,#v-1), timeout = 0, margin = 10 }
end
