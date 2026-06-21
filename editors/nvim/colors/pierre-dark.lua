vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "pierre-dark"
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
hl("Normal", { fg = "#fafafa", bg = "#0a0a0a" })
hl("NormalFloat", { fg = "#fafafa", bg = "#101010" })
hl("NormalNC", { fg = "#a3a3a3", bg = "#0a0a0a" })
hl("FloatBorder", { fg = "#636363", bg = "#101010" })
hl("Cursor", { fg = "#0a0a0a", bg = "#009fff" })
hl("CursorLine", { bg = "#101010" })
hl("CursorLineNr", { fg = "#fafafa", bold = true })
hl("LineNr", { fg = "#525252" })
hl("SignColumn", { bg = "#0a0a0a" })
hl("ColorColumn", { bg = "#101010" })
hl("Visual", { bg = "#19283c" })
hl("Search", { fg = "#0a0a0a", bg = "#ffde80" })
hl("IncSearch", { fg = "#0a0a0a", bg = "#ffba82" })
hl("Pmenu", { fg = "#fafafa", bg = "#101010" })
hl("PmenuSel", { fg = "#0a0a0a", bg = "#009fff" })
hl("PmenuSbar", { bg = "#101010" })
hl("PmenuThumb", { bg = "#525252" })
hl("StatusLine", { fg = "#d4d4d4", bg = "#171717" })
hl("StatusLineNC", { fg = "#737373", bg = "#0a0a0a" })
hl("TabLine", { fg = "#737373", bg = "#171717" })
hl("TabLineSel", { fg = "#fafafa", bg = "#0a0a0a" })
hl("TabLineFill", { bg = "#171717" })
hl("WinSeparator", { fg = "#1d1d1d" })
hl("VertSplit", { fg = "#1d1d1d" })
hl("Folded", { fg = "#737373", bg = "#101010" })
hl("FoldColumn", { fg = "#525252", bg = "#0a0a0a" })
hl("MatchParen", { fg = "#009fff", bold = true })
hl("NonText", { fg = "#525252" })
hl("Whitespace", { fg = "#525252" })
hl("EndOfBuffer", { fg = "#0a0a0a" })
hl("WildMenu", { fg = "#0a0a0a", bg = "#009fff" })

-- syntax
hl("Comment", { fg = "#737373", italic = true })
hl("Constant", { fg = "#ffd452" })
hl("String", { fg = "#5ecc71" })
hl("Character", { fg = "#5ecc71" })
hl("Number", { fg = "#68cdf2" })
hl("Float", { fg = "#68cdf2" })
hl("Boolean", { fg = "#68cdf2" })
hl("Identifier", { fg = "#ffa359" })
hl("Function", { fg = "#9d6afb" })
hl("Statement", { fg = "#ff678d" })
hl("Keyword", { fg = "#ff678d" })
hl("Conditional", { fg = "#ff678d" })
hl("Repeat", { fg = "#ff678d" })
hl("Operator", { fg = "#08c0ef" })
hl("Exception", { fg = "#ff678d" })
hl("PreProc", { fg = "#ff678d" })
hl("Include", { fg = "#ff678d" })
hl("Define", { fg = "#ff678d" })
hl("Macro", { fg = "#ff678d" })
hl("Type", { fg = "#d568ea" })
hl("StorageClass", { fg = "#ff678d" })
hl("Structure", { fg = "#d568ea" })
hl("Typedef", { fg = "#d568ea" })
hl("Special", { fg = "#61d5c0" })
hl("SpecialChar", { fg = "#61d5c0" })
hl("Tag", { fg = "#ff855e" })
hl("Delimiter", { fg = "#636363" })
hl("SpecialComment", { fg = "#737373" })
hl("Error", { fg = "#ff2e3f", bold = true })
hl("Todo", { fg = "#ffab16", bold = true })
hl("Underlined", { fg = "#009fff", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#61d5c0" })
hl("@string.special", { fg = "#64d1db" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#ffd452" })
hl("@constant.builtin", { fg = "#ffd452" })
hl("@variable", { fg = "#ffa359" })
hl("@variable.builtin", { fg = "#ffab16" })
hl("@variable.member", { fg = "#ffa359" })
hl("@variable.parameter", { fg = "#a3a3a3" })
hl("@function", { fg = "#9d6afb" })
hl("@function.builtin", { fg = "#9d6afb" })
hl("@function.call", { fg = "#9d6afb" })
hl("@function.method", { fg = "#9d6afb" })
hl("@function.method.call", { fg = "#9d6afb" })
hl("@type", { fg = "#d568ea" })
hl("@type.builtin", { fg = "#d568ea" })
hl("@type.definition", { fg = "#d568ea" })
hl("@attribute", { fg = "#69b1ff" })
hl("@property", { fg = "#ffa359" })
hl("@field", { fg = "#ffa359" })
hl("@constructor", { fg = "#d568ea" })
hl("@operator", { fg = "#08c0ef" })
hl("@punctuation.bracket", { fg = "#636363" })
hl("@punctuation.delimiter", { fg = "#636363" })
hl("@tag", { fg = "#ff855e" })
hl("@tag.attribute", { fg = "#60d199" })
hl("@tag.delimiter", { fg = "#636363" })
hl("@namespace", { fg = "#ffab16" })
hl("@module", { fg = "#ffab16" })

-- diagnostics
hl("DiagnosticError", { fg = "#ff2e3f" })
hl("DiagnosticWarn", { fg = "#ffca00" })
hl("DiagnosticInfo", { fg = "#08c0ef" })
hl("DiagnosticHint", { fg = "#69b1ff" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ff2e3f" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffca00" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#08c0ef" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#69b1ff" })

-- diff / git
hl("DiffAdd", { fg = "#07c480", bg = "#101010" })
hl("DiffChange", { fg = "#ffca00", bg = "#101010" })
hl("DiffDelete", { fg = "#ff2e3f", bg = "#101010" })
hl("DiffText", { fg = "#009fff", bg = "#101010" })
hl("GitSignsAdd", { fg = "#07c480" })
hl("GitSignsChange", { fg = "#ffca00" })
hl("GitSignsDelete", { fg = "#ff2e3f" })
