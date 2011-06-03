--------------------------------------- Main menu ---------------------------------------
appsmenu = {
	{ "Mathematica",	"mathematica" },
	{ "Boinc",		"boincmgr" },
	{ "DrScheme",		"drscheme" }
}
internetmenu = {
	{ "Emesene",		"emesene-2"},
	{ "Transmission",	"transmission-gtk"},
	{ "Uzbl",		"uzbl-browser"},
	{ "Midori",		"midori"},
	{ "Google Earth",	"googleearth"},
	{ "Wicd-client",	"wicd-client"},
	{ "Dropbox",		"/home/aparicio/.dropbox-dist/dropboxd"},
}
multimediamenu = {
	{ "GPicView",		"gpicview" },
	{ "Mirage",		"mirage" },
	{ "Gimp",		"gimp" },
	{ "ePDFViwer",		"epdfview" },
	{ "Gmpc",		"gmpc" },
	{ "Gnome Mplayer",	"gnome-mplayer" },
	{ "Audacity",		"audacity" },
	{ "ncmpc",		t("ncmpc") },
}
gamesmenu = {
	{ "AssaultCube",	"assaultcube" },
	{ "FooBillard",		"foobillard" },
	{ "FretsOnFire",	"FretsOnFire" },
	{ "SuperTuxKart",	"supertuxkart" },
	{ "Xmoto",		"xmoto" },
	{ "GL-117",		"gl-117" },
	{ "TeeWorlds",		"teeworlds" },
	{ "Chickens",		"chickens --window" },
	{ "CrashTest",		"crashtext" },
	{ "Steam",		"wine /home/aparicio/.wine/drive_c/Programas/Steam/Steam.exe" },
}
officemenu = {
	{ "Gnumeric",		"gnumeric" },
	{ "Abiword",		"abiword" },
	{ "ooWriter",		"lowriter" },
	{ "ooCalc",		"localc" },
	{ "ooImpress",		"loimpress" },
}
utilsmenu = {
	{ "Leafpad",		"leafpad" },
	{ "Character Map",	"gucharmap" },
	{ "Xkill",		"xkill" },
	{ "LXappearance",	"lxappearance" },
	{ "urxvt",		terminal },
	{ "htop",		t("htop") },
	{ "root shell",		t("su") },
	{ "conky",		t("conky") },
}
awesomemenu = {
	{ "Toggle battery status", battery.toggle },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}
mainmenu = awful.menu({ items = {
			{ "Casa",	function() spawn("skype") spawn("claws-mail") spawn("luakit") spawn(t("conky")) spawn(terminal)  end},
			{ "Skype",	"skype"},
			{ "Gmpc",	"gmpc"},
			{ "Claws Mail",	"claws-mail"},
			{ "internet",	internetmenu },
			{ "apps",	appsmenu },
			{ "multimedia",	multimediamenu },
			{ "games",	gamesmenu },
			{ "office",	officemenu },
			{ "utils",	utilsmenu },
			{ "awesome",	awesomemenu }
}})

--------------------------------------- Browser Menu ---------------------------------------
browsermenu = awful.menu({ items = {
			{ "GMail",	lspawn(browser.." gmail.com") },
			{ "Facebook",	lspawn(browser.." facebook.com") },
			{ "Reddit",	lspawn(browser.." reddit.com") },
}})

