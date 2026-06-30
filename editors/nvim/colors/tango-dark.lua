vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "tango-dark"
vim.o.background = "dark"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#000000"
vim.g.terminal_color_1 = "#cc0000"
vim.g.terminal_color_2 = "#4e9a06"
vim.g.terminal_color_3 = "#c4a000"
vim.g.terminal_color_4 = "#3465a4"
vim.g.terminal_color_5 = "#75507b"
vim.g.terminal_color_6 = "#06989a"
vim.g.terminal_color_7 = "#d3d7cf"
vim.g.terminal_color_8 = "#555753"
vim.g.terminal_color_9 = "#ef2929"
vim.g.terminal_color_10 = "#8ae234"
vim.g.terminal_color_11 = "#fce94f"
vim.g.terminal_color_12 = "#729fcf"
vim.g.terminal_color_13 = "#ad7fa8"
vim.g.terminal_color_14 = "#34e2e2"
vim.g.terminal_color_15 = "#eeeeec"

-- base UI
hl("Normal", { fg = "#d3d7cf", bg = "#000000" })
hl("NormalFloat", { fg = "#d3d7cf", bg = "#2e3436" })
hl("NormalNC", { fg = "#babdb6", bg = "#000000" })
hl("FloatBorder", { fg = "#555753", bg = "#2e3436" })
hl("Cursor", { fg = "#000000", bg = "#ffffff" })
hl("CursorLine", { bg = "#2e3436" })
hl("CursorLineNr", { fg = "#d3d7cf", bold = true })
hl("LineNr", { fg = "#555753" })
hl("SignColumn", { bg = "#000000" })
hl("ColorColumn", { bg = "#2e3436" })
hl("Visual", { bg = "#204a87" })
hl("Search", { fg = "#000000", bg = "#fce94f" })
hl("IncSearch", { fg = "#000000", bg = "#fcaf3e" })
hl("Pmenu", { fg = "#d3d7cf", bg = "#2e3436" })
hl("PmenuSel", { fg = "#000000", bg = "#729fcf" })
hl("PmenuSbar", { bg = "#2e3436" })
hl("PmenuThumb", { bg = "#555753" })
hl("StatusLine", { fg = "#d3d7cf", bg = "#2e3436" })
hl("StatusLineNC", { fg = "#888a85", bg = "#000000" })
hl("TabLine", { fg = "#888a85", bg = "#2e3436" })
hl("TabLineSel", { fg = "#d3d7cf", bg = "#000000" })
hl("TabLineFill", { bg = "#2e3436" })
hl("WinSeparator", { fg = "#555753" })
hl("VertSplit", { fg = "#555753" })
hl("Folded", { fg = "#888a85", bg = "#2e3436" })
hl("FoldColumn", { fg = "#555753", bg = "#000000" })
hl("MatchParen", { fg = "#729fcf", bold = true })
hl("NonText", { fg = "#555753" })
hl("Whitespace", { fg = "#555753" })
hl("EndOfBuffer", { fg = "#000000" })
hl("WildMenu", { fg = "#000000", bg = "#729fcf" })

-- syntax
hl("Comment", { fg = "#888a85", italic = true })
hl("Constant", { fg = "#fcaf3e" })
hl("String", { fg = "#8ae234" })
hl("Character", { fg = "#8ae234" })
hl("Number", { fg = "#34e2e2" })
hl("Float", { fg = "#34e2e2" })
hl("Boolean", { fg = "#34e2e2" })
hl("Identifier", { fg = "#d3d7cf" })
hl("Function", { fg = "#fce94f" })
hl("Statement", { fg = "#729fcf" })
hl("Keyword", { fg = "#729fcf" })
hl("Conditional", { fg = "#729fcf" })
hl("Repeat", { fg = "#729fcf" })
hl("Operator", { fg = "#34e2e2" })
hl("Exception", { fg = "#729fcf" })
hl("PreProc", { fg = "#729fcf" })
hl("Include", { fg = "#729fcf" })
hl("Define", { fg = "#729fcf" })
hl("Macro", { fg = "#729fcf" })
hl("Type", { fg = "#ad7fa8" })
hl("StorageClass", { fg = "#729fcf" })
hl("Structure", { fg = "#ad7fa8" })
hl("Typedef", { fg = "#ad7fa8" })
hl("Special", { fg = "#34e2e2" })
hl("SpecialChar", { fg = "#34e2e2" })
hl("Tag", { fg = "#fcaf3e" })
hl("Delimiter", { fg = "#888a85" })
hl("SpecialComment", { fg = "#888a85" })
hl("Error", { fg = "#ef2929", bold = true })
hl("Todo", { fg = "#fcaf3e", bold = true })
hl("Underlined", { fg = "#729fcf", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#34e2e2" })
hl("@string.special", { fg = "#34e2e2" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#fcaf3e" })
hl("@constant.builtin", { fg = "#fcaf3e" })
hl("@variable", { fg = "#d3d7cf" })
hl("@variable.builtin", { fg = "#fcaf3e" })
hl("@variable.member", { fg = "#d3d7cf" })
hl("@variable.parameter", { fg = "#babdb6" })
hl("@function", { fg = "#fce94f" })
hl("@function.builtin", { fg = "#fce94f" })
hl("@function.call", { fg = "#fce94f" })
hl("@function.method", { fg = "#fce94f" })
hl("@function.method.call", { fg = "#fce94f" })
hl("@type", { fg = "#ad7fa8" })
hl("@type.builtin", { fg = "#ad7fa8" })
hl("@type.definition", { fg = "#ad7fa8" })
hl("@attribute", { fg = "#8ae234" })
hl("@property", { fg = "#d3d7cf" })
hl("@field", { fg = "#d3d7cf" })
hl("@constructor", { fg = "#ad7fa8" })
hl("@operator", { fg = "#34e2e2" })
hl("@punctuation.bracket", { fg = "#888a85" })
hl("@punctuation.delimiter", { fg = "#888a85" })
hl("@tag", { fg = "#fcaf3e" })
hl("@tag.attribute", { fg = "#8ae234" })
hl("@tag.delimiter", { fg = "#888a85" })
hl("@namespace", { fg = "#fcaf3e" })
hl("@module", { fg = "#fcaf3e" })

-- diagnostics
hl("DiagnosticError", { fg = "#ef2929" })
hl("DiagnosticWarn", { fg = "#fce94f" })
hl("DiagnosticInfo", { fg = "#34e2e2" })
hl("DiagnosticHint", { fg = "#729fcf" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ef2929" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#fce94f" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#34e2e2" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#729fcf" })

-- diff / git
hl("DiffAdd", { fg = "#8ae234", bg = "#2e3436" })
hl("DiffChange", { fg = "#fce94f", bg = "#2e3436" })
hl("DiffDelete", { fg = "#ef2929", bg = "#2e3436" })
hl("DiffText", { fg = "#729fcf", bg = "#2e3436" })
hl("GitSignsAdd", { fg = "#8ae234" })
hl("GitSignsChange", { fg = "#fce94f" })
hl("GitSignsDelete", { fg = "#ef2929" })
