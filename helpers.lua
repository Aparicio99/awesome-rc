local spawn = awful.spawn
local async = awful.spawn.easy_async

function out(s, t)
	naughty.notify({ text=s, timeout=t })
end

function rout(s, t)
	naughty.notify({ text=s, timeout=t, replaces_id=0 })
end

function urgent(s1, s2)
	naughty.notify({ title=s1, text=s2, bg="#ff0000", fg="#000000"})
end

function program_exists(cmd)
		-- Returns: (integer) The forked PID.
		-- Or (string) Error message.
		return type(spawn(cmd) == "number")
end


-- Spawn program and show output in notification
function spawn_out(cmd, timeout)
	async(cmd, function(output)
		rout(output, timeout)
	end)
end

-- Simplify calls to external programs in places where a function is expected
function lspawn(s)
	return function() awful.spawn(s) end
end

function t(s)
	return terminal.." -e "..s
end

function mkprompt(p, f, c)
	return function ()
		awful.prompt.run({
			prompt  = p,
			textbox = awful.screen.focused().promptbox.widget,
			exe_callback = f,
			history_path = c
		})
	end
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

function sleep()
	if not program_exists("pidof xscreensaver") then
		out("sleeping...")
		spawn("afk true")

		keygrabber.run( function(mod, key, event)
			if event == "press" then
				keygrabber.stop()
				spawn("afk false")
			end
		end)
	else
		spawn("xscreensaver-command -lock")
	end
end

-- Move windows to adjacent desktops
function shift_to_tag(n)
	return function(c)
		local screen = awful.screen.focused()

		local current_id = awful.tag.getidx(screen.selected_tag);
		local next_id = ((current_id + n - 1) % NUM_TAGS) + 1

		local next_screen = screen.tags[next_id]
		awful.client.movetotag(next_screen)
		awful.tag.viewonly(next_screen)
	end
end

last_focus = {}

-- Hide/Show all windows matching some property
function toggle_hidden(prop, ...)

	local args = {...}
	local windows = {}
	local all_hidden = false
	local focus = false
	local id = args[1] -- Use the first name as the identifier for a group

	for i, c in ipairs(client.get()) do
		for j, value in ipairs(args) do
			if c[prop] == value then
				table.insert(windows, c)

				all_hidden = all_hidden or c.hidden
				if c == client.focus then
					last_focus[id] = c
					focus = true
				end
			end
		end
	end

	if all_hidden then
		for i, c in ipairs(windows) do
			c.hidden = false
			c:raise()
		end
		if last_focus[id] and last_focus[id].valid then
			client.focus = last_focus[id]
		end

	elseif next(windows) then
		if focus then
			for i, c in ipairs(windows) do
				c.hidden = true
			end
		else
			if not last_focus[id] or not last_focus[id].valid then
				last_focus[id] = windows[1]
			end

			client.focus = last_focus[id]
			last_focus[id]:raise()
		end
	else
		rout("No hidden windows found")
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

-- Returns a copy of the table without the entries rejected by the filter function
function filter_table(tbl, filter)
	local ret = {}
	for _, v in pairs(tbl) do
		if not filter(v) then
			table.insert(ret, v)
		end
	end
	return ret
end

-- Swap all normal windows between the visible clients in each screen
function swap_screens()

	if screen.count() ~= 2 then -- not implemented
		return
	end

	local clients = {}

	for s = 1, 2 do
		local filter = function(c)
			return c.screen.index == s
			   and c.type == "normal"
			   and not c.hidden
			   and not c.sticky
			   and c:isvisible()
		end
		clients[s] = {}
		for c in awful.client.iterate(filter) do
			table.insert(clients[s], c)
		end
	end

	for i, c in ipairs(clients[1]) do
		awful.client.movetoscreen(c, 2)
	end

	for i, c in ipairs(clients[2]) do
		awful.client.movetoscreen(c, 1)
	end
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

-- vim:ts=4:sw=4
