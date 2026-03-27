local wezterm = require("wezterm")

local is_dark = wezterm.gui.get_appearance():find("Dark") -- Match the terminal theme to the operating-system appearance.

wezterm.on("gui-startup", function(cmd) -- Maximize newly spawned GUI windows.
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return {
    color_scheme = is_dark and "Dark 2026" or "Catppuccin Latte", -- Select theme for current appearance.
    font = wezterm.font_with_fallback({ -- Use Iosevka with Nerd Font symbols as fallback.
        { family = "Iosevka Extended", weight = "Regular", italic = false },
        { family = "Symbols Nerd Font" },
    }),
    font_rules = { -- Replace synthetic bold/italic faces with explicit font choices.
        {
            intensity = "Bold",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "IosevkaExtended", weight = "Bold" },
                { family = "Symbols Nerd Font" },
            }),
        },
        {
            intensity = "Normal",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "Iosevka Extended", italic = false },
                { family = "Symbols Nerd Font" },
            }),
        },
        {
            intensity = "Bold",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "IosevkaExtended", weight = "Bold", italic = false },
                { family = "Symbols Nerd Font" },
            }),
        },
    },
    freetype_load_flags = "DEFAULT", -- Use FreeType's default load flags.
    freetype_load_target = "Light", -- Use light hinting for glyph rasterization.
    freetype_render_target = "HorizontalLcd", -- Render text with horizontal LCD subpixel antialiasing.
    allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace", -- Permit square glyphs to fit when followed by a space.
    adjust_window_size_when_changing_font_size = true, -- Resize the window when the font size changes.
    cursor_thickness = "1px", -- Draw a thin cursor.
    cursor_blink_rate = 200, -- Blink the cursor every 200ms.
    enable_scroll_bar = true, -- Show a scrollbar for scrollback.
    hide_tab_bar_if_only_one_tab = true, -- Hide the tab bar when only one tab is open.
    window_padding = { -- Keep terminal content away from the window edge.
        left = 12,
        right = 12,
        top = 12,
        bottom = 12,
    },

    underline_thickness = "2px", -- Draw underlines at a readable thickness.
    underline_position = "-4pt", -- Lower underlines to align visually with Iosevka.
    default_prog = { "zsh", "-l" }, -- Start an interactive login zsh.
    harfbuzz_features = { "kern", "liga", "clig", "calt" }, -- Enable common shaping and ligature features.
    notification_handling = "SuppressFromFocusedPane", -- Suppress notifications when the focused pane produced them.
    mouse_bindings = { -- Bind right-click to paste from the clipboard.
        {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = wezterm.action.PasteFrom("Clipboard"),
        },
    },

    keys = { -- Keyboard shortcuts for common terminal actions.
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") }, -- Copy the selection to the clipboard.
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") }, -- Paste clipboard text.
        {
            key = "f",
            mods = "CTRL|SHIFT",
            action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
        }, -- Search the current selection or prompt for a search term.
        { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") }, -- Open a new tab in the current domain.
        {
            key = "w",
            mods = "CTRL|SHIFT",
            action = wezterm.action.CloseCurrentTab({ confirm = true }),
        }, -- Close the current tab after confirmation.
        { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow }, -- Open a new window.
        { key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize }, -- Increase the font size.
        { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize }, -- Decrease the font size.
        { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize }, -- Reset the font size.
    },
}
