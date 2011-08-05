--------------------------------------- Helpers ---------------------------------------

function out(s, t)
	naughty.notify({ text=s, timeout=t })
end

function rout(s, t)
	naughty.notify({ text=s, timeout=t, replaces_id=0 })
end

function urgent(s1, s2)
	naughty.notify({ title=s1, text=s2, bg="#ff0000", fg="#000000"})
end

-- Spawn program and show output in notification
function spawn_out(s, t)
	rout(pread(s), t)
end

-- Simplify calls to external programs in places where a function is expected
function lspawn(s)
	return function() spawn(s) end
end

function t(s)
	return terminal.." -e "..s
end

function mkprompt(p, f, c)
	return function () awful.prompt.run({ prompt = p }, promptbox.widget, f, nil, c) end
end

function round(what, precision)
	return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

-- Show notification with layout information 
function layoutinfo()
	rout(	"Masters: " .. awful.tag.getnmaster() ..
		"\nColumns: " .. awful.tag.getncol() ..
		"\nFactor: " .. awful.tag.getmwfact(), 2)
end

function dmenu()
	 spawn("dmenu_run -i -p 'Run:' -nb '" ..
		beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
		"' -sb '" .. beautiful.bg_focus ..
		"' -sf '" .. beautiful.fg_focus .. "'")
end

-- Move windows to adjacent desktops
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

-- Hide/Show all windows matching some property
function toggle_hidden(prop, value)
	for i, c in ipairs(client.get()) do
		if c[prop] == value then
			if c.hidden then
				c.hidden = false
				client.focus = c
				c:raise()
			else
				if c ~= client.focus then
					client.focus = c
					c:raise()
				else
					c.hidden = true
				end
			end
		end
	end
end

-- Get the client with some property, like instance of value conky
function getclient(prop, val)
	for i, c in ipairs(client.get()) do
		if c[prop] == val then
			return c
		end
	end
end

-- Set the factor being always multiple of 5
function incmwfact5(factor)
	local val = math.ceil(awful.tag.getmwfact() * 100) -- math.ceil is to correct a weird bug
	val = ((val - (val%5)) / 100) + factor             -- if getmwfact() seems to return 0.65, that value is different from 0.65
	awful.tag.setmwfact(val)                           -- so 65%5 return 5 instead of 0
end

-- Show notification with all the info about the focused window
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
