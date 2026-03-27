vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "vscode-2026-dark"
vim.o.background = "dark"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#0d1117"
vim.g.terminal_color_1 = "#ff7b72"
vim.g.terminal_color_2 = "#7ee787"
vim.g.terminal_color_3 = "#e5ba7d"
vim.g.terminal_color_4 = "#79c0ff"
vim.g.terminal_color_5 = "#d2a8ff"
vim.g.terminal_color_6 = "#a5d6ff"
vim.g.terminal_color_7 = "#bbbebf"
vim.g.terminal_color_8 = "#8b949e"
vim.g.terminal_color_9 = "#ff7b72"
vim.g.terminal_color_10 = "#7ee787"
vim.g.terminal_color_11 = "#e5ba7d"
vim.g.terminal_color_12 = "#79c0ff"
vim.g.terminal_color_13 = "#d2a8ff"
vim.g.terminal_color_14 = "#a5d6ff"
vim.g.terminal_color_15 = "#c9d1d9"

-- base UI
hl("Normal", { fg = "#bbbebf", bg = "#121314" })
hl("NormalFloat", { fg = "#bbbebf", bg = "#191a1b" })
hl("NormalNC", { fg = "#8c8c8c", bg = "#121314" })
hl("FloatBorder", { fg = "#8c8c8c", bg = "#191a1b" })
hl("Cursor", { fg = "#121314", bg = "#e5ba7d" })
hl("CursorLine", { bg = "#191a1b" })
hl("CursorLineNr", { fg = "#bbbebf", bold = true })
hl("LineNr", { fg = "#8b949e" })
hl("SignColumn", { bg = "#121314" })
hl("ColorColumn", { bg = "#191a1b" })
hl("Visual", { bg = "#276782" })
hl("Search", { fg = "#121314", bg = "#e5ba7d" })
hl("IncSearch", { fg = "#121314", bg = "#ffa657" })
hl("Pmenu", { fg = "#bbbebf", bg = "#191a1b" })
hl("PmenuSel", { fg = "#121314", bg = "#79c0ff" })
hl("PmenuSbar", { bg = "#191a1b" })
hl("PmenuThumb", { bg = "#8c8c8c" })
hl("StatusLine", { fg = "#bbbebf", bg = "#191a1b" })
hl("StatusLineNC", { fg = "#8c8c8c", bg = "#121314" })
hl("TabLine", { fg = "#8c8c8c", bg = "#191a1b" })
hl("TabLineSel", { fg = "#bbbebf", bg = "#121314" })
hl("TabLineFill", { bg = "#191a1b" })
hl("WinSeparator", { fg = "#8c8c8c" })
hl("VertSplit", { fg = "#8c8c8c" })
hl("Folded", { fg = "#8b949e", bg = "#191a1b" })
hl("FoldColumn", { fg = "#8b949e", bg = "#121314" })
hl("MatchParen", { fg = "#e5ba7d", bold = true })
hl("NonText", { fg = "#8c8c8c" })
hl("Whitespace", { fg = "#8c8c8c" })
hl("EndOfBuffer", { fg = "#121314" })
hl("WildMenu", { fg = "#121314", bg = "#79c0ff" })

-- syntax
hl("Comment", { fg = "#8b949e", italic = true })
hl("Constant", { fg = "#d2a8ff" })
hl("String", { fg = "#7ee787" })
hl("Character", { fg = "#7ee787" })
hl("Number", { fg = "#ffa657" })
hl("Float", { fg = "#ffa657" })
hl("Boolean", { fg = "#d2a8ff" })
hl("Identifier", { fg = "#bbbebf" })
hl("Function", { fg = "#79c0ff" })
hl("Statement", { fg = "#d2a8ff" })
hl("Keyword", { fg = "#d2a8ff" })
hl("Conditional", { fg = "#d2a8ff" })
hl("Repeat", { fg = "#d2a8ff" })
hl("Operator", { fg = "#d2a8ff" })
hl("Exception", { fg = "#d2a8ff" })
hl("PreProc", { fg = "#d2a8ff" })
hl("Include", { fg = "#d2a8ff" })
hl("Define", { fg = "#d2a8ff" })
hl("Macro", { fg = "#d2a8ff" })
hl("Type", { fg = "#e5ba7d" })
hl("StorageClass", { fg = "#d2a8ff" })
hl("Structure", { fg = "#e5ba7d" })
hl("Typedef", { fg = "#e5ba7d" })
hl("Special", { fg = "#a5d6ff" })
hl("SpecialChar", { fg = "#a5d6ff" })
hl("Tag", { fg = "#ff7b72" })
hl("Delimiter", { fg = "#8c8c8c" })
hl("SpecialComment", { fg = "#8b949e" })
hl("Error", { fg = "#ff7b72", bold = true })
hl("Todo", { fg = "#ffa657", bold = true })
hl("Underlined", { fg = "#79c0ff", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#d2a8ff" })
hl("@string.special", { fg = "#a5d6ff" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#d2a8ff" })
hl("@constant.builtin", { fg = "#ffa657" })
hl("@variable", { fg = "#bbbebf" })
hl("@variable.builtin", { fg = "#ffa657" })
hl("@variable.member", { fg = "#a5d6ff" })
hl("@variable.parameter", { fg = "#bbbebf" })
hl("@function", { fg = "#79c0ff" })
hl("@function.builtin", { fg = "#a5d6ff" })
hl("@function.call", { fg = "#79c0ff" })
hl("@function.method", { fg = "#79c0ff" })
hl("@function.method.call", { fg = "#79c0ff" })
hl("@type", { fg = "#e5ba7d" })
hl("@type.builtin", { fg = "#e5ba7d" })
hl("@type.definition", { fg = "#e5ba7d" })
hl("@attribute", { fg = "#ffa657" })
hl("@property", { fg = "#a5d6ff" })
hl("@field", { fg = "#a5d6ff" })
hl("@constructor", { fg = "#e5ba7d" })
hl("@operator", { fg = "#d2a8ff" })
hl("@punctuation.bracket", { fg = "#8c8c8c" })
hl("@punctuation.delimiter", { fg = "#8c8c8c" })
hl("@tag", { fg = "#ff7b72" })
hl("@tag.attribute", { fg = "#ffa657" })
hl("@tag.delimiter", { fg = "#8c8c8c" })
hl("@namespace", { fg = "#bbbebf" })
hl("@module", { fg = "#bbbebf" })

-- diagnostics
hl("DiagnosticError", { fg = "#ff7b72" })
hl("DiagnosticWarn", { fg = "#e5ba7d" })
hl("DiagnosticInfo", { fg = "#a5d6ff" })
hl("DiagnosticHint", { fg = "#79c0ff" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ff7b72" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#e5ba7d" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#a5d6ff" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#79c0ff" })

-- diff / git
hl("DiffAdd", { fg = "#7ee787", bg = "#191a1b" })
hl("DiffChange", { fg = "#e5ba7d", bg = "#191a1b" })
hl("DiffDelete", { fg = "#ff7b72", bg = "#191a1b" })
hl("DiffText", { fg = "#79c0ff", bg = "#191a1b" })
hl("GitSignsAdd", { fg = "#7ee787" })
hl("GitSignsChange", { fg = "#e5ba7d" })
hl("GitSignsDelete", { fg = "#ff7b72" })
