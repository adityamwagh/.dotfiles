vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "revontuli-night"
vim.o.background = "dark"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#414141"
vim.g.terminal_color_1 = "#ff3344"
vim.g.terminal_color_2 = "#5fff33"
vim.g.terminal_color_3 = "#ff9233"
vim.g.terminal_color_4 = "#33aaff"
vim.g.terminal_color_5 = "#d970ff"
vim.g.terminal_color_6 = "#33ffff"
vim.g.terminal_color_7 = "#dfdfdf"
vim.g.terminal_color_8 = "#464646"
vim.g.terminal_color_9 = "#ff1d3f"
vim.g.terminal_color_10 = "#57ff1a"
vim.g.terminal_color_11 = "#ff7513"
vim.g.terminal_color_12 = "#15a5ff"
vim.g.terminal_color_13 = "#d258ff"
vim.g.terminal_color_14 = "#00ddff"
vim.g.terminal_color_15 = "#e1e1e1"

-- base UI
hl("Normal", { fg = "#ffffff", bg = "#000000" })
hl("NormalFloat", { fg = "#ffffff", bg = "#0a0a0a" })
hl("NormalNC", { fg = "#9f9f9f", bg = "#000000" })
hl("FloatBorder", { fg = "#606060", bg = "#0a0a0a" })
hl("Cursor", { fg = "#000000", bg = "#33ffa0" })
hl("CursorLine", { bg = "#0d0d0d" })
hl("CursorLineNr", { fg = "#33ffa0", bold = true })
hl("LineNr", { fg = "#bfbfbf" })
hl("SignColumn", { bg = "#000000" })
hl("ColorColumn", { bg = "#0d0d0d" })
hl("Visual", { bg = "#144364" })
hl("Search", { fg = "#000000", bg = "#33ffa0" })
hl("IncSearch", { fg = "#000000", bg = "#33ffff" })
hl("Pmenu", { fg = "#ffffff", bg = "#0a0a0a" })
hl("PmenuSel", { fg = "#000000", bg = "#33aaff" })
hl("PmenuSbar", { bg = "#0a0a0a" })
hl("PmenuThumb", { bg = "#606060" })
hl("StatusLine", { fg = "#ffffff", bg = "#1a1a1a" })
hl("StatusLineNC", { fg = "#9f9f9f", bg = "#000000" })
hl("TabLine", { fg = "#9f9f9f", bg = "#0a0a0a" })
hl("TabLineSel", { fg = "#ffffff", bg = "#000000" })
hl("TabLineFill", { bg = "#0a0a0a" })
hl("WinSeparator", { fg = "#1a1a1a" })
hl("VertSplit", { fg = "#1a1a1a" })
hl("Folded", { fg = "#9f9f9f", bg = "#0d0d0d" })
hl("FoldColumn", { fg = "#606060", bg = "#000000" })
hl("MatchParen", { fg = "#33ffa0", bold = true })
hl("NonText", { fg = "#414141" })
hl("Whitespace", { fg = "#414141" })
hl("EndOfBuffer", { fg = "#000000" })
hl("WildMenu", { fg = "#000000", bg = "#33aaff" })

-- syntax (Kate canonical)
hl("Comment", { fg = "#707070", italic = true })
hl("Constant", { fg = "#33ffff", bold = true })
hl("String", { fg = "#00ee00" })
hl("Character", { fg = "#33aaff" })
hl("Number", { fg = "#d970ff", bold = true })
hl("Float", { fg = "#d970ff", bold = true })
hl("Boolean", { fg = "#d970ff", bold = true })
hl("Identifier", { fg = "#ff9233" })
hl("Function", { fg = "#838fff", bold = true })
hl("Statement", { fg = "#33aaff" })
hl("Keyword", { fg = "#33aaff", bold = true })
hl("Conditional", { fg = "#33ffa0", italic = true })
hl("Repeat", { fg = "#33ffa0", italic = true })
hl("Operator", { fg = "#33ffa0" })
hl("Exception", { fg = "#33ffa0", italic = true })
hl("PreProc", { fg = "#ffe033", bold = true })
hl("Include", { fg = "#d970ff" })
hl("Define", { fg = "#ffe033", bold = true })
hl("Macro", { fg = "#ffe033", bold = true })
hl("Type", { fg = "#33ffff" })
hl("StorageClass", { fg = "#33aaff", bold = true })
hl("Structure", { fg = "#33ffff" })
hl("Typedef", { fg = "#33ffff" })
hl("Special", { fg = "#ffe033" })
hl("SpecialChar", { fg = "#ffe033", italic = true })
hl("Tag", { fg = "#ffe033", italic = true })
hl("Delimiter", { fg = "#9f9f9f" })
hl("SpecialComment", { fg = "#838fff", italic = true })
hl("Error", { fg = "#ff3344", bold = true })
hl("Todo", { fg = "#ffe033", bold = true })
hl("Underlined", { fg = "#33aaff", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { fg = "#33ffa0", italic = true })
hl("@keyword.operator", { fg = "#33ffa0" })
hl("@keyword.conditional", { fg = "#33ffa0", italic = true })
hl("@keyword.repeat", { fg = "#33ffa0", italic = true })
hl("@keyword.import", { fg = "#d970ff" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#ffe033", italic = true })
hl("@string.special", { fg = "#ffe033" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#33ffff", bold = true })
hl("@constant.builtin", { fg = "#33ffff", bold = true })
hl("@variable", { fg = "#ff9233" })
hl("@variable.builtin", { fg = "#ff3344" })
hl("@variable.member", { fg = "#ff9233" })
hl("@variable.parameter", { fg = "#ffffff" })
hl("@function", { fg = "#838fff", bold = true })
hl("@function.builtin", { fg = "#838fff", bold = true })
hl("@function.call", { fg = "#838fff" })
hl("@function.method", { fg = "#838fff" })
hl("@function.method.call", { fg = "#838fff" })
hl("@type", { fg = "#33ffff" })
hl("@type.builtin", { fg = "#33ffff" })
hl("@type.definition", { fg = "#33ffff" })
hl("@attribute", { fg = "#ffe033", italic = true })
hl("@property", { fg = "#ff9233" })
hl("@field", { fg = "#ff9233" })
hl("@constructor", { fg = "#33ffff" })
hl("@operator", { fg = "#33ffa0" })
hl("@punctuation.bracket", { fg = "#9f9f9f" })
hl("@punctuation.delimiter", { fg = "#9f9f9f" })
hl("@tag", { fg = "#33aaff", bold = true })
hl("@tag.attribute", { fg = "#ffe033", italic = true })
hl("@tag.delimiter", { fg = "#9f9f9f" })
hl("@namespace", { fg = "#838fff" })
hl("@module", { fg = "#838fff" })

-- diagnostics
hl("DiagnosticError", { fg = "#ff3344" })
hl("DiagnosticWarn", { fg = "#ff9233" })
hl("DiagnosticInfo", { fg = "#33aaff" })
hl("DiagnosticHint", { fg = "#33ffa0" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ff3344" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#ff9233" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#33aaff" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#33ffa0" })

-- diff / git
hl("DiffAdd", { fg = "#5fff33", bg = "#0d0d0d" })
hl("DiffChange", { fg = "#ff9233", bg = "#0d0d0d" })
hl("DiffDelete", { fg = "#ff3344", bg = "#0d0d0d" })
hl("DiffText", { fg = "#33aaff", bg = "#0d0d0d" })
hl("GitSignsAdd", { fg = "#5fff33" })
hl("GitSignsChange", { fg = "#ff9233" })
hl("GitSignsDelete", { fg = "#ff3344" })
