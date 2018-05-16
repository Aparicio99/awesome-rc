---------------------------
-- Orange awesome theme --
---------------------------

local orange1 = "#ff8c00"
local orange2 = "#ff9900"
local gray1 = "#090909"
local gray2 = "#222222"
local white1 = "#dddddd"
local red1 = "#ff0000"

theme = {}

theme.font          = "sans 8"

theme.bg_normal     = gray1
theme.bg_focus      = gray1
theme.bg_urgent     = red1
theme.bg_minimize   = gray2
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = white1
theme.fg_focus      = orange1
theme.fg_urgent     = white1
theme.fg_minimize   = white1

theme.border_width  = 1
theme.border_normal = gray2
theme.border_focus  = orange1
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

dir = config .. "/themes/custom/"

-- Display the taglist squares
theme.taglist_squares_sel   = dir .. "taglist/squaref.png"
theme.taglist_squares_unsel = dir .. "taglist/square.png"

theme.tasklist_floating_icon =		dir .. "tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = dir .. "icons/submenu.png"
theme.menu_height = 24
theme.menu_width  = 120
theme.systray_icon_spacing = 2

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.wallpaper = dir .. "background.png"

-- You can use your own layout icons like this:
theme.layout_fairh =		dir .. "layouts/fairh.png"
theme.layout_fairv =		dir .. "layouts/fairv.png"
theme.layout_floating  =	dir .. "layouts/floating.png"
theme.layout_magnifier =	dir .. "layouts/magnifier.png"
theme.layout_max =		dir .. "layouts/max.png"
theme.layout_fullscreen =	dir .. "layouts/fullscreen.png"
theme.layout_tilebottom =	dir .. "layouts/tilebottom.png"
theme.layout_tileleft   =	dir .. "layouts/tileleft.png"
theme.layout_tile =		dir .. "layouts/tile.png"
theme.layout_tiletop =		dir .. "layouts/tiletop.png"
theme.layout_spiral  =		dir .. "layouts/spiral.png"
theme.layout_dwindle =		dir .. "layouts/dwindle.png"

theme.tux_icon          = dir .. "icons/tux.png"
theme.firefox_icon      = dir .. "icons/firefox.png"
theme.skype_icon        = dir .. "icons/skype.png"
theme.email_icon        = dir .. "icons/email.png"
theme.internet_icon     = dir .. "icons/internet.png"
theme.multimedia_icon   = dir .. "icons/multimedia.png"
theme.games_icon        = dir .. "icons/games.png"
theme.office_icon       = dir .. "icons/office.png"
theme.utils_icon        = dir .. "icons/utils.png"
theme.awesome_icon      = dir .. "icons/awesome.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
