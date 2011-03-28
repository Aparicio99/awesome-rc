---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#333333"
theme.bg_focus      = "#666666"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#333333"
theme.border_focus  = "#666666"
theme.border_marked = "#91231c"

dir = "/home/aparicio/.config/awesome/themes/default/"
theme.wallpaper_cmd = { "feh --bg-tile " .. dir .. "wallpaper.png" }


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   =		dir .. "taglist/squaref.png"
theme.taglist_squares_unsel = 		dir .. "taglist/square.png"

theme.tasklist_floating_icon = 		dir .. "tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = 		dir .. "submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
--theme.titlebar_close_button_normal =			dir .. "titlebar/close_normal.png"
--theme.titlebar_close_button_focus  = 			dir .. "titlebar/close_focus.png"
--
--theme.titlebar_ontop_button_normal_inactive = 		dir .. "titlebar/ontop_normal_inactive.png"
--theme.titlebar_ontop_button_focus_inactive  = 		dir .. "titlebar/ontop_focus_inactive.png"
--theme.titlebar_ontop_button_normal_active = 		dir .. "titlebar/ontop_normal_active.png"
--theme.titlebar_ontop_button_focus_active  = 		dir .. "titlebar/ontop_focus_active.png"
--
--theme.titlebar_sticky_button_normal_inactive = 		dir .. "titlebar/sticky_normal_inactive.png"
--theme.titlebar_sticky_button_focus_inactive  = 		dir .. "titlebar/sticky_focus_inactive.png"
--theme.titlebar_sticky_button_normal_active = 		dir .. "titlebar/sticky_normal_active.png"
--theme.titlebar_sticky_button_focus_active  = 		dir .. "titlebar/sticky_focus_active.png"
--
--theme.titlebar_floating_button_normal_inactive = 	dir .. "titlebar/floating_normal_inactive.png"
--theme.titlebar_floating_button_focus_inactive  = 	dir .. "titlebar/floating_focus_inactive.png"
--theme.titlebar_floating_button_normal_active =		dir .. "titlebar/floating_normal_active.png"
--theme.titlebar_floating_button_focus_active  =		dir .. "titlebar/floating_focus_active.png"
--
--theme.titlebar_maximized_button_normal_inactive =	dir .. "titlebar/maximized_normal_inactive.png"
--theme.titlebar_maximized_button_focus_inactive  =	dir .. "titlebar/maximized_focus_inactive.png"
--theme.titlebar_maximized_button_normal_active = 	dir .. "titlebar/maximized_normal_active.png"
--theme.titlebar_maximized_button_focus_active  = 	dir .. "titlebar/maximized_focus_active.png"


-- You can use your own layout icons like this:
theme.layout_fairh = 		dir .. "layouts/fairh.png"
theme.layout_fairv = 		dir .. "layouts/fairv.png"
theme.layout_floating  = 	dir .. "layouts/floating.png"
theme.layout_magnifier = 	dir .. "layouts/magnifier.png"
theme.layout_max = 		dir .. "layouts/max.png"
theme.layout_fullscreen = 	dir .. "layouts/fullscreen.png"
theme.layout_tilebottom = 	dir .. "layouts/tilebottom.png"
theme.layout_tileleft   = 	dir .. "layouts/tileleft.png"
theme.layout_tile = 		dir .. "layouts/tile.png"
theme.layout_tiletop = 		dir .. "layouts/tiletop.png"
theme.layout_spiral  = 		dir .. "layouts/spiral.png"
theme.layout_dwindle = 		dir .. "layouts/dwindle.png"

theme.awesome_icon = dir .. "awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
