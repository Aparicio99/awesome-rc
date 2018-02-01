awful.rules.rules = {

	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
			 border_color = beautiful.border_normal,
			 focus = awful.client.focus.filter,
			 raise = true,
			 keys = clientkeys,
			 buttons = clientbuttons,
			 size_hints_honor = false }
	},

	-- Floating
	{ rule_any = {	class = { "MPlayer", "gimp", "Gmpc", "Transmission", "Minecraft", "Steam", "Pinentry" },
			name = { "File Transfers", "cal", "ncmpc", "puff", "feh" } },
			properties = { floating = true }
	},

	-- Floating and fixed
	{ rule_any = { class = {"Skype", "Pidgin", "Telegram"} },
	  properties = { floating = true, sticky = true, ontop = true }
	},

	-- Other
	{ rule = { class = "Firefox", type = "normal" },
	  properties = { tag = tags[1][1] }
	},
	{ rule = { class = "Firefox", instance = "Toplevel" },
	  properties = { floating = true }
	},
	{ rule = { name = "xeyes" },
	  properties = { floating = true, skip_taskbar = true, sticky = true }
	},
	{ rule = { class = "Claws-mail", role = "compose" },
	  properties = {  floating = true}
	},
	{ rule = { class = "Claws-mail", role = "mainwindow" },
	  properties = { maximized_horizontal = true, maximized_vertical = true, sticky = true}
	},
	{ rule = { class = "Boincmgr" },
	  properties = { floating = true, skip_taskbar = true}
	},
	{ rule = { class = "RocketLeague" },
	  properties = { fullscreen = true }
	},

	-- Drop consoles
	{ rule_any = { instance = {"dropterm1", "dropterm2", "dropterm3"} },
	  properties = { floating = true, ontop = true, skip_taskbar = true, sticky = true, hidden = true },
	  callback = function(c)
	    if c.instance == "dropterm1" then
		    drop.setprop(c, 1, true)
	    elseif c.instance == "dropterm2" then
		    drop.setprop(c, 2, true)
	    elseif c.instance == "dropterm3" then
		    drop.setprop(c, 3, true)
	    end
	  end
	},

	-- Right fixed Conky
	{ rule = { class = "conky"  },
	  properties = { floating = true,
	                 focus = false,
                         sticky = true,
                         skip_taskbar = true,
                         border_color = beautiful.bg_normal },
	  callback = conky.callback
	}
}
