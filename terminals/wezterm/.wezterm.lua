local wezterm = require("wezterm")

local is_dark = wezterm.gui.get_appearance():find("Dark") -- Match the terminal theme to the operating-system appearance.
local is_macos = wezterm.target_triple:find("darwin") ~= nil
local hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(hyperlink_rules, {
    regex = [[\b([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)#(\d+)\b]],
    format = "https://github.com/$1/issues/$2",
})

table.insert(hyperlink_rules, {
    regex = [[\b(/(?:[-A-Za-z0-9_+.@%]+/)*[-A-Za-z0-9_+.@%]+)(?::\d+)?\b]],
    format = "file://$1",
    highlight = 1,
})

local function basename(path)
    return path:gsub("/$", ""):match("([^/]+)$") or path
end

local function format_cwd(pane)
    local cwd_uri = pane:get_current_working_dir()

    if not cwd_uri then
        return "~"
    end

    local cwd = type(cwd_uri) == "userdata" and cwd_uri.file_path
        or cwd_uri:gsub("^file://[^/]*", "")

    if cwd == os.getenv("HOME") then
        return "~"
    end

    return basename(cwd)
end

local status_colors = is_dark
        and { background = "#121314", foreground = "#bbbebf", accent = "#79c0ff" }
    or { background = "#eff1f5", foreground = "#4c4f69", accent = "#1e66f5" }

wezterm.on("gui-startup", function(cmd) -- Maximize newly spawned GUI windows.
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

wezterm.on("update-status", function(window, pane)
    local workspace = window:active_workspace()
    local domain = pane:get_domain_name()
    local cwd = format_cwd(pane)
    local time = wezterm.strftime("%H:%M")

    window:set_right_status(wezterm.format({
        { Background = { Color = status_colors.background } },
        { Foreground = { Color = status_colors.accent } },
        { Text = " " .. cwd .. " " },
        { Foreground = { Color = status_colors.foreground } },
        { Text = "| " .. domain .. " | " .. workspace .. " | " .. time .. " " },
    }))
end)

return {
    color_scheme = is_dark and "Doom One" or "Doom One Light", -- Select theme for current appearance.
    font_size = is_macos and 16 or 11, -- macOS Retina needs larger point size than Linux.
    hyperlink_rules = hyperlink_rules, -- Extend default URL detection with GitHub refs and local paths.
    font = wezterm.font_with_fallback({ -- Use Source Code Pro with Nerd Font symbols as fallback.
        { family = "Source Code Pro", weight = "Regular", italic = false },
        { family = "Symbols Nerd Font" },
    }),
    font_rules = { -- Replace synthetic bold/italic faces with explicit font choices.
        {
            intensity = "Bold",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "Source Code Pro", weight = "Bold" },
                { family = "Symbols Nerd Font" },
            }),
        },
        {
            intensity = "Normal",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "Source Code Pro", italic = false },
                { family = "Symbols Nerd Font" },
            }),
        },
        {
            intensity = "Bold",
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "Source Code Pro", weight = "Bold", italic = false },
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
    hide_tab_bar_if_only_one_tab = false, -- Keep the tab bar visible for the status area.
    status_update_interval = 1000, -- Refresh the status area every second.
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
