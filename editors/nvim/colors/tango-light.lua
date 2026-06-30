vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "tango-light"
vim.o.background = "light"

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
hl("Normal", { fg = "#555753", bg = "#ffffff" })
hl("NormalFloat", { fg = "#555753", bg = "#eeeeec" })
hl("NormalNC", { fg = "#888a85", bg = "#ffffff" })
hl("FloatBorder", { fg = "#babdb6", bg = "#eeeeec" })
hl("Cursor", { fg = "#ffffff", bg = "#000000" })
hl("CursorLine", { bg = "#eeeeec" })
hl("CursorLineNr", { fg = "#2e3436", bold = true })
hl("LineNr", { fg = "#babdb6" })
hl("SignColumn", { bg = "#ffffff" })
hl("ColorColumn", { bg = "#eeeeec" })
hl("Visual", { bg = "#c5d6ec" })
hl("Search", { fg = "#2e3436", bg = "#fce94f" })
hl("IncSearch", { fg = "#2e3436", bg = "#fcaf3e" })
hl("Pmenu", { fg = "#555753", bg = "#eeeeec" })
hl("PmenuSel", { fg = "#ffffff", bg = "#3465a4" })
hl("PmenuSbar", { bg = "#eeeeec" })
hl("PmenuThumb", { bg = "#babdb6" })
hl("StatusLine", { fg = "#2e3436", bg = "#d3d7cf" })
hl("StatusLineNC", { fg = "#888a85", bg = "#ffffff" })
hl("TabLine", { fg = "#888a85", bg = "#d3d7cf" })
hl("TabLineSel", { fg = "#2e3436", bg = "#ffffff" })
hl("TabLineFill", { bg = "#d3d7cf" })
hl("WinSeparator", { fg = "#babdb6" })
hl("VertSplit", { fg = "#babdb6" })
hl("Folded", { fg = "#888a85", bg = "#eeeeec" })
hl("FoldColumn", { fg = "#babdb6", bg = "#ffffff" })
hl("MatchParen", { fg = "#3465a4", bold = true })
hl("NonText", { fg = "#babdb6" })
hl("Whitespace", { fg = "#babdb6" })
hl("EndOfBuffer", { fg = "#ffffff" })
hl("WildMenu", { fg = "#ffffff", bg = "#3465a4" })

-- syntax
hl("Comment", { fg = "#888a85", italic = true })
hl("Constant", { fg = "#ce5c00" })
hl("String", { fg = "#4e9a06" })
hl("Character", { fg = "#4e9a06" })
hl("Number", { fg = "#06989a" })
hl("Float", { fg = "#06989a" })
hl("Boolean", { fg = "#06989a" })
hl("Identifier", { fg = "#555753" })
hl("Function", { fg = "#c4a000" })
hl("Statement", { fg = "#3465a4" })
hl("Keyword", { fg = "#3465a4" })
hl("Conditional", { fg = "#3465a4" })
hl("Repeat", { fg = "#3465a4" })
hl("Operator", { fg = "#06989a" })
hl("Exception", { fg = "#3465a4" })
hl("PreProc", { fg = "#3465a4" })
hl("Include", { fg = "#3465a4" })
hl("Define", { fg = "#3465a4" })
hl("Macro", { fg = "#3465a4" })
hl("Type", { fg = "#75507b" })
hl("StorageClass", { fg = "#3465a4" })
hl("Structure", { fg = "#75507b" })
hl("Typedef", { fg = "#75507b" })
hl("Special", { fg = "#06989a" })
hl("SpecialChar", { fg = "#06989a" })
hl("Tag", { fg = "#ce5c00" })
hl("Delimiter", { fg = "#888a85" })
hl("SpecialComment", { fg = "#888a85" })
hl("Error", { fg = "#cc0000", bold = true })
hl("Todo", { fg = "#ce5c00", bold = true })
hl("Underlined", { fg = "#3465a4", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#06989a" })
hl("@string.special", { fg = "#06989a" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#ce5c00" })
hl("@constant.builtin", { fg = "#ce5c00" })
hl("@variable", { fg = "#555753" })
hl("@variable.builtin", { fg = "#ce5c00" })
hl("@variable.member", { fg = "#555753" })
hl("@variable.parameter", { fg = "#888a85" })
hl("@function", { fg = "#c4a000" })
hl("@function.builtin", { fg = "#c4a000" })
hl("@function.call", { fg = "#c4a000" })
hl("@function.method", { fg = "#c4a000" })
hl("@function.method.call", { fg = "#c4a000" })
hl("@type", { fg = "#75507b" })
hl("@type.builtin", { fg = "#75507b" })
hl("@type.definition", { fg = "#75507b" })
hl("@attribute", { fg = "#4e9a06" })
hl("@property", { fg = "#555753" })
hl("@field", { fg = "#555753" })
hl("@constructor", { fg = "#75507b" })
hl("@operator", { fg = "#06989a" })
hl("@punctuation.bracket", { fg = "#888a85" })
hl("@punctuation.delimiter", { fg = "#888a85" })
hl("@tag", { fg = "#ce5c00" })
hl("@tag.attribute", { fg = "#4e9a06" })
hl("@tag.delimiter", { fg = "#888a85" })
hl("@namespace", { fg = "#ce5c00" })
hl("@module", { fg = "#ce5c00" })

-- diagnostics
hl("DiagnosticError", { fg = "#cc0000" })
hl("DiagnosticWarn", { fg = "#c4a000" })
hl("DiagnosticInfo", { fg = "#06989a" })
hl("DiagnosticHint", { fg = "#3465a4" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#cc0000" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#c4a000" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#06989a" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#3465a4" })

-- diff / git
hl("DiffAdd", { fg = "#4e9a06", bg = "#eeeeec" })
hl("DiffChange", { fg = "#c4a000", bg = "#eeeeec" })
hl("DiffDelete", { fg = "#cc0000", bg = "#eeeeec" })
hl("DiffText", { fg = "#3465a4", bg = "#eeeeec" })
hl("GitSignsAdd", { fg = "#4e9a06" })
hl("GitSignsChange", { fg = "#c4a000" })
hl("GitSignsDelete", { fg = "#cc0000" })
