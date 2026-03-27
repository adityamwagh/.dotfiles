vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "vscode-2026-light"
vim.o.background = "light"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#1f2328"
vim.g.terminal_color_1 = "#cf222e"
vim.g.terminal_color_2 = "#116329"
vim.g.terminal_color_3 = "#667309"
vim.g.terminal_color_4 = "#0550ae"
vim.g.terminal_color_5 = "#8250df"
vim.g.terminal_color_6 = "#0a3069"
vim.g.terminal_color_7 = "#202020"
vim.g.terminal_color_8 = "#6e7781"
vim.g.terminal_color_9 = "#cf222e"
vim.g.terminal_color_10 = "#116329"
vim.g.terminal_color_11 = "#667309"
vim.g.terminal_color_12 = "#0550ae"
vim.g.terminal_color_13 = "#8250df"
vim.g.terminal_color_14 = "#0a3069"
vim.g.terminal_color_15 = "#202020"

-- base UI
hl("Normal", { fg = "#202020", bg = "#ffffff" })
hl("NormalFloat", { fg = "#202020", bg = "#fafafd" })
hl("NormalNC", { fg = "#606060", bg = "#ffffff" })
hl("FloatBorder", { fg = "#606060", bg = "#fafafd" })
hl("Cursor", { fg = "#ffffff", bg = "#667309" })
hl("CursorLine", { bg = "#fafafd" })
hl("CursorLineNr", { fg = "#202020", bold = true })
hl("LineNr", { fg = "#6e7781" })
hl("SignColumn", { bg = "#ffffff" })
hl("ColorColumn", { bg = "#fafafd" })
hl("Visual", { bg = "#0069cc" })
hl("Search", { fg = "#ffffff", bg = "#667309" })
hl("IncSearch", { fg = "#ffffff", bg = "#953800" })
hl("Pmenu", { fg = "#202020", bg = "#fafafd" })
hl("PmenuSel", { fg = "#ffffff", bg = "#0550ae" })
hl("PmenuSbar", { bg = "#fafafd" })
hl("PmenuThumb", { bg = "#606060" })
hl("StatusLine", { fg = "#202020", bg = "#fafafd" })
hl("StatusLineNC", { fg = "#606060", bg = "#ffffff" })
hl("TabLine", { fg = "#606060", bg = "#fafafd" })
hl("TabLineSel", { fg = "#202020", bg = "#ffffff" })
hl("TabLineFill", { bg = "#fafafd" })
hl("WinSeparator", { fg = "#606060" })
hl("VertSplit", { fg = "#606060" })
hl("Folded", { fg = "#6e7781", bg = "#fafafd" })
hl("FoldColumn", { fg = "#6e7781", bg = "#ffffff" })
hl("MatchParen", { fg = "#667309", bold = true })
hl("NonText", { fg = "#606060" })
hl("Whitespace", { fg = "#606060" })
hl("EndOfBuffer", { fg = "#ffffff" })
hl("WildMenu", { fg = "#ffffff", bg = "#0550ae" })

-- syntax
hl("Comment", { fg = "#6e7781", italic = true })
hl("Constant", { fg = "#8250df" })
hl("String", { fg = "#116329" })
hl("Character", { fg = "#116329" })
hl("Number", { fg = "#953800" })
hl("Float", { fg = "#953800" })
hl("Boolean", { fg = "#8250df" })
hl("Identifier", { fg = "#202020" })
hl("Function", { fg = "#0550ae" })
hl("Statement", { fg = "#8250df" })
hl("Keyword", { fg = "#8250df" })
hl("Conditional", { fg = "#8250df" })
hl("Repeat", { fg = "#8250df" })
hl("Operator", { fg = "#8250df" })
hl("Exception", { fg = "#8250df" })
hl("PreProc", { fg = "#8250df" })
hl("Include", { fg = "#8250df" })
hl("Define", { fg = "#8250df" })
hl("Macro", { fg = "#8250df" })
hl("Type", { fg = "#667309" })
hl("StorageClass", { fg = "#8250df" })
hl("Structure", { fg = "#667309" })
hl("Typedef", { fg = "#667309" })
hl("Special", { fg = "#0a3069" })
hl("SpecialChar", { fg = "#0a3069" })
hl("Tag", { fg = "#cf222e" })
hl("Delimiter", { fg = "#606060" })
hl("SpecialComment", { fg = "#6e7781" })
hl("Error", { fg = "#cf222e", bold = true })
hl("Todo", { fg = "#953800", bold = true })
hl("Underlined", { fg = "#0550ae", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#8250df" })
hl("@string.special", { fg = "#0a3069" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#8250df" })
hl("@constant.builtin", { fg = "#953800" })
hl("@variable", { fg = "#202020" })
hl("@variable.builtin", { fg = "#953800" })
hl("@variable.member", { fg = "#0a3069" })
hl("@variable.parameter", { fg = "#202020" })
hl("@function", { fg = "#0550ae" })
hl("@function.builtin", { fg = "#0a3069" })
hl("@function.call", { fg = "#0550ae" })
hl("@function.method", { fg = "#0550ae" })
hl("@function.method.call", { fg = "#0550ae" })
hl("@type", { fg = "#667309" })
hl("@type.builtin", { fg = "#667309" })
hl("@type.definition", { fg = "#667309" })
hl("@attribute", { fg = "#953800" })
hl("@property", { fg = "#0a3069" })
hl("@field", { fg = "#0a3069" })
hl("@constructor", { fg = "#667309" })
hl("@operator", { fg = "#8250df" })
hl("@punctuation.bracket", { fg = "#606060" })
hl("@punctuation.delimiter", { fg = "#606060" })
hl("@tag", { fg = "#cf222e" })
hl("@tag.attribute", { fg = "#953800" })
hl("@tag.delimiter", { fg = "#606060" })
hl("@namespace", { fg = "#202020" })
hl("@module", { fg = "#202020" })

-- diagnostics
hl("DiagnosticError", { fg = "#cf222e" })
hl("DiagnosticWarn", { fg = "#667309" })
hl("DiagnosticInfo", { fg = "#0a3069" })
hl("DiagnosticHint", { fg = "#0550ae" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#cf222e" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#667309" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#0a3069" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#0550ae" })

-- diff / git
hl("DiffAdd", { fg = "#116329", bg = "#fafafd" })
hl("DiffChange", { fg = "#667309", bg = "#fafafd" })
hl("DiffDelete", { fg = "#cf222e", bg = "#fafafd" })
hl("DiffText", { fg = "#0550ae", bg = "#fafafd" })
hl("GitSignsAdd", { fg = "#116329" })
hl("GitSignsChange", { fg = "#667309" })
hl("GitSignsDelete", { fg = "#cf222e" })
