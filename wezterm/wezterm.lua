-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16
config.enable_tab_bar = true
config.window_decorations = "RESIZE"

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

-- show tabs
config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

-- and finally, return the configuration to wezterm
return config
