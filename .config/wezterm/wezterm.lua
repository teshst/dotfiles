-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- hold the configuration.
local config = wezterm.config_builder()

-- Appearance
config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'catppuccin-macchiato'

-- Disable tab bar
config.enable_tab_bar = false

-- Dim inactive pane
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- Set intial size
config.initial_cols = 200
config.initial_rows = 50

-- return the configuration to wezterm
return config
