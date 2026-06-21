vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "pierre-dark-soft"
vim.o.background = "dark"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#171717"
vim.g.terminal_color_1 = "#ff2e3f"
vim.g.terminal_color_2 = "#0dbe4e"
vim.g.terminal_color_3 = "#ffca00"
vim.g.terminal_color_4 = "#009fff"
vim.g.terminal_color_5 = "#e130ac"
vim.g.terminal_color_6 = "#08c0ef"
vim.g.terminal_color_7 = "#bcbcbc"
vim.g.terminal_color_8 = "#171717"
vim.g.terminal_color_9 = "#ff2e3f"
vim.g.terminal_color_10 = "#86c427"
vim.g.terminal_color_11 = "#ffca00"
vim.g.terminal_color_12 = "#009fff"
vim.g.terminal_color_13 = "#e130ac"
vim.g.terminal_color_14 = "#08c0ef"
vim.g.terminal_color_15 = "#bcbcbc"

-- base UI
hl("Normal", { fg = "#d4d4d4", bg = "#171717" })
hl("NormalFloat", { fg = "#d4d4d4", bg = "#1d1d1d" })
hl("NormalNC", { fg = "#8a8a8a", bg = "#171717" })
hl("FloatBorder", { fg = "#525252", bg = "#1d1d1d" })
hl("Cursor", { fg = "#171717", bg = "#69b1ff" })
hl("CursorLine", { bg = "#1d1d1d" })
hl("CursorLineNr", { fg = "#d4d4d4", bold = true })
hl("LineNr", { fg = "#737373" })
hl("SignColumn", { bg = "#171717" })
hl("ColorColumn", { bg = "#1d1d1d" })
hl("Visual", { bg = "#1f3e5e" })
hl("Search", { fg = "#171717", bg = "#ffde80" })
hl("IncSearch", { fg = "#171717", bg = "#ffba82" })
hl("Pmenu", { fg = "#d4d4d4", bg = "#1d1d1d" })
hl("PmenuSel", { fg = "#171717", bg = "#69b1ff" })
hl("PmenuSbar", { bg = "#1d1d1d" })
hl("PmenuThumb", { bg = "#525252" })
hl("StatusLine", { fg = "#bcbcbc", bg = "#101010" })
hl("StatusLineNC", { fg = "#636363", bg = "#171717" })
hl("TabLine", { fg = "#636363", bg = "#101010" })
hl("TabLineSel", { fg = "#d4d4d4", bg = "#171717" })
hl("TabLineFill", { bg = "#101010" })
hl("WinSeparator", { fg = "#262626" })
hl("VertSplit", { fg = "#262626" })
hl("Folded", { fg = "#636363", bg = "#1d1d1d" })
hl("FoldColumn", { fg = "#525252", bg = "#171717" })
hl("MatchParen", { fg = "#69b1ff", bold = true })
hl("NonText", { fg = "#525252" })
hl("Whitespace", { fg = "#525252" })
hl("EndOfBuffer", { fg = "#171717" })
hl("WildMenu", { fg = "#171717", bg = "#69b1ff" })

-- syntax
hl("Comment", { fg = "#636363", italic = true })
hl("Constant", { fg = "#ffde80" })
hl("String", { fg = "#8cda94" })
hl("Character", { fg = "#8cda94" })
hl("Number", { fg = "#96d9f6" })
hl("Float", { fg = "#96d9f6" })
hl("Boolean", { fg = "#96d9f6" })
hl("Identifier", { fg = "#ffba82" })
hl("Function", { fg = "#ba8ffd" })
hl("Statement", { fg = "#ff91a8" })
hl("Keyword", { fg = "#ff91a8" })
hl("Conditional", { fg = "#ff91a8" })
hl("Repeat", { fg = "#ff91a8" })
hl("Operator", { fg = "#68cdf2" })
hl("Exception", { fg = "#ff91a8" })
hl("PreProc", { fg = "#ff91a8" })
hl("Include", { fg = "#ff91a8" })
hl("Define", { fg = "#ff91a8" })
hl("Macro", { fg = "#ff91a8" })
hl("Type", { fg = "#e290f0" })
hl("StorageClass", { fg = "#ff91a8" })
hl("Structure", { fg = "#e290f0" })
hl("Typedef", { fg = "#e290f0" })
hl("Special", { fg = "#8fe0d0" })
hl("SpecialChar", { fg = "#8fe0d0" })
hl("Tag", { fg = "#ffa685" })
hl("Delimiter", { fg = "#737373" })
hl("SpecialComment", { fg = "#636363" })
hl("Error", { fg = "#ff6762", bold = true })
hl("Todo", { fg = "#ffbc56", bold = true })
hl("Underlined", { fg = "#69b1ff", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#8fe0d0" })
hl("@string.special", { fg = "#92dde4" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#ffde80" })
hl("@constant.builtin", { fg = "#ffde80" })
hl("@variable", { fg = "#ffba82" })
hl("@variable.builtin", { fg = "#ffbc56" })
hl("@variable.member", { fg = "#ffba82" })
hl("@variable.parameter", { fg = "#8a8a8a" })
hl("@function", { fg = "#ba8ffd" })
hl("@function.builtin", { fg = "#ba8ffd" })
hl("@function.call", { fg = "#ba8ffd" })
hl("@function.method", { fg = "#ba8ffd" })
hl("@function.method.call", { fg = "#ba8ffd" })
hl("@type", { fg = "#e290f0" })
hl("@type.builtin", { fg = "#e290f0" })
hl("@type.definition", { fg = "#e290f0" })
hl("@attribute", { fg = "#97c4ff" })
hl("@property", { fg = "#ffba82" })
hl("@field", { fg = "#ffba82" })
hl("@constructor", { fg = "#e290f0" })
hl("@operator", { fg = "#68cdf2" })
hl("@punctuation.bracket", { fg = "#737373" })
hl("@punctuation.delimiter", { fg = "#737373" })
hl("@tag", { fg = "#ffa685" })
hl("@tag.attribute", { fg = "#8eddb2" })
hl("@tag.delimiter", { fg = "#737373" })
hl("@namespace", { fg = "#ffbc56" })
hl("@module", { fg = "#ffbc56" })

-- diagnostics
hl("DiagnosticError", { fg = "#ff6762" })
hl("DiagnosticWarn", { fg = "#ffd452" })
hl("DiagnosticInfo", { fg = "#68cdf2" })
hl("DiagnosticHint", { fg = "#97c4ff" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ff6762" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffd452" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#68cdf2" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#97c4ff" })

-- diff / git
hl("DiffAdd", { fg = "#60d199", bg = "#1d1d1d" })
hl("DiffChange", { fg = "#ffd452", bg = "#1d1d1d" })
hl("DiffDelete", { fg = "#ff6762", bg = "#1d1d1d" })
hl("DiffText", { fg = "#69b1ff", bg = "#1d1d1d" })
hl("GitSignsAdd", { fg = "#60d199" })
hl("GitSignsChange", { fg = "#ffd452" })
hl("GitSignsDelete", { fg = "#ff6762" })
