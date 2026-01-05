local wezterm = require("wezterm")

-- Get the directory where this config file actually lives (follow symlinks)
local config_dir = wezterm.home_dir .. "/.dotfiles/terminals/wezterm/"

-- Load custom themes
local everforest_dark_hard = dofile(config_dir .. "themes/everforest-dark-hard.lua")

-- Detect system appearance (light/dark)
local appearance = wezterm.gui.get_appearance()
local is_dark = appearance:find("Dark")

-- wezterm.on('gui-startup', function(cmd)
-- local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

return {
	-- Dynamic theme switching
	color_scheme = is_dark and nil or "Catppuccin Latte",
	colors = is_dark and everforest_dark_hard or nil,
	-- Fonts
	font = wezterm.font_with_fallback({
		{ family = "SourceCodeVF", weight = "Regular", italic = false },
		{ family = "Symbols Nerd Font" },
	}),
	font_size = 14,
	font_rules = {
		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "SourceCodeVF", weight = "Bold" },
				{ family = "Symbols Nerd Font" },
			}),
		},
		{
			intensity = "Normal",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "SourceCodeVF", italic = false },
				{ family = "Symbols Nerd Font" },
			}),
		},
		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "SourceCodeVF", weight = "Bold", italic = false },
				{ family = "Symbols Nerd Font" },
			}),
		},
	},
	freetype_load_flags = "DEFAULT",
	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	adjust_window_size_when_changing_font_size = true,
	-- Cursor
	cursor_thickness = "1px",
	cursor_blink_rate = 200,
	enable_scroll_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	-- Window padding (balanced)
	window_padding = {
		left = 12,
		right = 12,
		top = 12,
		bottom = 12,
	},

	-- Size of new windows
	initial_cols = 120,
	initial_rows = 40,
	-- Underline adjustment (WezTerm equivalent)
	underline_thickness = "2px",
	underline_position = "-4pt",
	-- Shell integration
	default_prog = { "zsh", "-l" },
	-- Synthetic font style substitution
	harfbuzz_features = { "kern", "liga", "clig", "calt" },
	-- Notification handling
	notification_handling = "SuppressFromFocusedPane",
	-- Mouse bindings - Right click to paste
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
	},

	-- Keybindings
	keys = {
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
		{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
		{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
		{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
	},
}
