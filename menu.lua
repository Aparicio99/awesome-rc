local spawn = awful.spawn

internetmenu = {
	{ "Transmission",   "transmission-remote-gtk"},
	{ "Google Chrome",  "google-chrome-stable"},
}
multimediamenu = {
	{ "GPicView",       "gpicview" },
	{ "Gimp",           "gimp" },
	{ "Gmpc",           "gmpc" },
	{ "ncmpc",          t("ncmpc") },
	{ "ncmpcpp",        t("ncmpcpp") },
}
gamesmenu = {
	{ "Steam",          "steam" },
	{ "SuperTuxKart",   "supertuxkart" },
	{ "Xmoto",          "xmoto" },
	{ "TeeWorlds",      "teeworlds" },
	{ "CrashTest",      "crashtext" },
}
officemenu = {
	{ "Gnumeric",       "gnumeric" },
	{ "loWriter",       "lowriter" },
	{ "loCalc",         "localc" },
	{ "ooImpress",      "loimpress" },
}
utilsmenu = {
	{ "Leafpad",        "leafpad" },
	{ "Character Map",  "gucharmap" },
	{ "Xkill",          "xkill" },
	{ "LXappearance",   "lxappearance" },
	{ "terminal",       terminal },
	{ "htop",           t("htop") },
	{ "root shell",     t("su") },
	{ "conky",          "conky" },
}

awesomemenu = {
   { "manual",      terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart",     awesome.restart },
   { "quit",        function() awesome.quit() end}
}

return awful.menu({ items = {
	{ "&Start",      function()
						spawn("Telegram")
						spawn("claws-mail")
						spawn("firefox")
	                 end, beautiful.tux_icon },

	{ "&Firefox",    "firefox",       beautiful.firefox_icon },
	{ "&Telegram",   "Telegram",      beautiful.skype_icon },
	{ "&Claws Mail", "claws-mail",    beautiful.email_icon },

	{ "internet",    internetmenu,    beautiful.internet_icon },
	{ "multimedia",  multimediamenu,  beautiful.multimedia_icon },
	{ "games",       gamesmenu,       beautiful.games_icon },
	{ "office",      officemenu,      beautiful.office_icon },
	{ "utils",       utilsmenu,       beautiful.utils_icon },
	{ "awesome",     awesomemenu,     beautiful.awesome_icon }
}})

-- vim:ts=4:sw=4
