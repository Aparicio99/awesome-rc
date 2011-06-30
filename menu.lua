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
			{ "GMail",	browser.." gmail.com" },
			{ "Facebook",	browser.." facebook.com" },
			{ "Reddit",	browser.." reddit.com" },
}})

--------------------------------------- Clipboard Menu ---------------------------------------
clipmenu = awful.menu({ width = 200,  items = {
			{ "Clear",			"clip clear all" },
			{ "Selection -> Clipboard",	"clip sel cli" },
			{ "Clipboard -> Selection",	"clip cli sel" },
			{ "Save Selection",		"clip sel sec" },
			{ "Restore Selection",		"clip sec sel" },
			{ "Dump Selection", function()
						local sel = pread("clip sel")
						if string.len(sel) ~= 0 then out(sel, 0)
						else out("Selection empty")
						end
					    end },
			{ "Dump Clipboard", function()
						local cli = pread("clip cli")
						if string.len(cli) ~= 0 then out(cli, 0)
						else out("Clipboard empty")
						end
					    end },
}})
