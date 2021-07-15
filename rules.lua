local telegram_width = 639

awful.rules.rules = {

	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
	                 border_color = beautiful.border_normal,
		             focus = awful.client.focus.filter,
		             raise = true,
		             keys = clientkeys,
		             buttons = clientbuttons,
		             screen = awful.screen.preferred,
		             placement = awful.placement.no_overlap+awful.placement.no_offscreen,
		             size_hints_honor = false }
	},

	-- Let the client decide the position
	{ rule = { name = "ncmpc" },
	  properties = { placement = awful.placement.restore }},

	-- Floating
	{ rule_any = {
		class = { "mpv", "gimp", "Gmpc", "Transmission", "Minecraft", "Steam", "Pinentry" },
		name  = { "File Transfers", "cal", "ncmpc", "puff", "feh" } },
	  properties = { floating = true }
	},

	-- Floating and fixed
	{ rule_any = { name = { "Telegram" } },
	  properties = { floating = true,
	                 sticky   = true,
	                 ontop    = true,
	                 height   = awful.screen.focused().geometry.height - beautiful.menu_height,
	                 width    = telegram_width,
	                 x        = awful.screen.focused().geometry.width - telegram_width - 2,
	                 y        = 21 }
	},

	{ rule = { instance = "Telegram", name = "Media viewer" },
	  properties = { maximized = true, ontop = true }
	},

	-- Other
	{ rule = { class = "Firefox", type = "normal" },
	  properties = { screen = 1, tag = "1" }
	},
	{ rule = { class = "Firefox", instance = "Toplevel" },
	  properties = { floating = true }
	},
	{ rule = { name = "xeyes" },
	  properties = { floating = true, skip_taskbar = true, sticky = true }
	},
	{ rule = { class = "Claws-mail", role = "mainwindow" },
	  properties = { maximized = true, sticky = true, hidden = true}
	},
	{ rule = { class = "Evolution", type = "normal" },
	  properties = { maximized = true, sticky = true, hidden = true }
	},
	{ rule = { class = "Evolution", icon_name = "Compose Message" },
	  properties = { maximized = false, sticky = false, hidden = false, floating = true }
	},
	{ rule_any = { role = {"compose"}, type = {"dialog"} },
	  properties = {  floating = true, maximized = false}
	},
	{ rule = { name = "Microsoft Teams Notification" },
	  properties = { floating = true, focusable = false, screen = 1 }
	},
	{ rule = { class = "Firefox", name = "Picture-in-Picture" },
	  properties = { maximized = false, sticky = true, ontop = true, skip_taskbar = true, floating = true }
	},

	-- Drop consoles
	{ rule_any = { instance = {"dropterm1", "dropterm2", "dropterm3"} },
	  properties = { floating = true, ontop = true, skip_taskbar = true, sticky = true, hidden = true },
	  callback = function(c)
	    if c.instance == "dropterm1" then
		    dropdown.setprop(c, 1, true)
	    elseif c.instance == "dropterm2" then
		    dropdown.setprop(c, 2, true)
	    elseif c.instance == "dropterm3" then
		    dropdown.setprop(c, 3, true)
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

-- vim:ts=4:sw=4
