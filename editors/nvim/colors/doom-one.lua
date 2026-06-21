vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "doom-one"
vim.o.background = "dark"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#1b2229"
vim.g.terminal_color_1 = "#ff6c6b"
vim.g.terminal_color_2 = "#98be65"
vim.g.terminal_color_3 = "#ecbe7b"
vim.g.terminal_color_4 = "#51afef"
vim.g.terminal_color_5 = "#c678dd"
vim.g.terminal_color_6 = "#46d9ff"
vim.g.terminal_color_7 = "#bbc2cf"
vim.g.terminal_color_8 = "#5b6268"
vim.g.terminal_color_9 = "#ff6c6b"
vim.g.terminal_color_10 = "#98be65"
vim.g.terminal_color_11 = "#ecbe7b"
vim.g.terminal_color_12 = "#51afef"
vim.g.terminal_color_13 = "#c678dd"
vim.g.terminal_color_14 = "#46d9ff"
vim.g.terminal_color_15 = "#dfdfdf"

-- base UI
hl("Normal", { fg = "#bbc2cf", bg = "#282c34" })
hl("NormalFloat", { fg = "#bbc2cf", bg = "#21242b" })
hl("NormalNC", { fg = "#bbc2cf", bg = "#282c34" })
hl("FloatBorder", { fg = "#5b6268", bg = "#21242b" })
hl("Cursor", { fg = "#282c34", bg = "#51afef" })
hl("CursorLine", { bg = "#21242b" })
hl("CursorLineNr", { fg = "#bbc2cf", bold = true })
hl("LineNr", { fg = "#5b6268" })
hl("SignColumn", { bg = "#282c34" })
hl("ColorColumn", { bg = "#21242b" })
hl("Visual", { bg = "#42444a" })
hl("Search", { fg = "#282c34", bg = "#ecbe7b" })
hl("IncSearch", { fg = "#282c34", bg = "#da8548" })
hl("Pmenu", { fg = "#bbc2cf", bg = "#21242b" })
hl("PmenuSel", { fg = "#282c34", bg = "#51afef" })
hl("PmenuSbar", { bg = "#21242b" })
hl("PmenuThumb", { bg = "#3f444a" })
hl("StatusLine", { fg = "#bbc2cf", bg = "#1c1f24" })
hl("StatusLineNC", { fg = "#5b6268", bg = "#282c34" })
hl("TabLine", { fg = "#5b6268", bg = "#1c1f24" })
hl("TabLineSel", { fg = "#bbc2cf", bg = "#282c34" })
hl("TabLineFill", { bg = "#1c1f24" })
hl("WinSeparator", { fg = "#1c1f24" })
hl("VertSplit", { fg = "#1c1f24" })
hl("Folded", { fg = "#5b6268", bg = "#21242b" })
hl("FoldColumn", { fg = "#5b6268", bg = "#282c34" })
hl("MatchParen", { fg = "#51afef", bold = true })
hl("NonText", { fg = "#3f444a" })
hl("Whitespace", { fg = "#3f444a" })
hl("EndOfBuffer", { fg = "#282c34" })
hl("WildMenu", { fg = "#282c34", bg = "#51afef" })

-- syntax
hl("Comment", { fg = "#5b6268", italic = true })
hl("Constant", { fg = "#a9a1e1" })
hl("String", { fg = "#98be65" })
hl("Character", { fg = "#98be65" })
hl("Number", { fg = "#da8548" })
hl("Float", { fg = "#da8548" })
hl("Boolean", { fg = "#da8548" })
hl("Identifier", { fg = "#dcaee8" })
hl("Function", { fg = "#c678dd" })
hl("Statement", { fg = "#51afef" })
hl("Keyword", { fg = "#51afef" })
hl("Conditional", { fg = "#51afef" })
hl("Repeat", { fg = "#51afef" })
hl("Operator", { fg = "#51afef" })
hl("Exception", { fg = "#51afef" })
hl("PreProc", { fg = "#51afef" })
hl("Include", { fg = "#51afef" })
hl("Define", { fg = "#51afef" })
hl("Macro", { fg = "#51afef" })
hl("Type", { fg = "#ecbe7b" })
hl("StorageClass", { fg = "#51afef" })
hl("Structure", { fg = "#ecbe7b" })
hl("Typedef", { fg = "#ecbe7b" })
hl("Special", { fg = "#46d9ff" })
hl("SpecialChar", { fg = "#46d9ff" })
hl("Tag", { fg = "#ff6c6b" })
hl("Delimiter", { fg = "#bbc2cf" })
hl("SpecialComment", { fg = "#5699af" })
hl("Error", { fg = "#ff6c6b", bold = true })
hl("Todo", { fg = "#ecbe7b", bold = true })
hl("Underlined", { fg = "#51afef", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#46d9ff" })
hl("@string.special", { fg = "#46d9ff" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#a9a1e1" })
hl("@constant.builtin", { fg = "#a9a1e1" })
hl("@variable", { fg = "#dcaee8" })
hl("@variable.builtin", { fg = "#ff6c6b" })
hl("@variable.member", { fg = "#dcaee8" })
hl("@variable.parameter", { fg = "#bbc2cf" })
hl("@function", { fg = "#c678dd" })
hl("@function.builtin", { fg = "#c678dd" })
hl("@function.call", { fg = "#c678dd" })
hl("@function.method", { fg = "#46d9ff" })
hl("@function.method.call", { fg = "#46d9ff" })
hl("@type", { fg = "#ecbe7b" })
hl("@type.builtin", { fg = "#ecbe7b" })
hl("@type.definition", { fg = "#ecbe7b" })
hl("@attribute", { fg = "#a9a1e1" })
hl("@property", { fg = "#dcaee8" })
hl("@field", { fg = "#dcaee8" })
hl("@constructor", { fg = "#ecbe7b" })
hl("@operator", { fg = "#51afef" })
hl("@punctuation.bracket", { fg = "#bbc2cf" })
hl("@punctuation.delimiter", { fg = "#bbc2cf" })
hl("@tag", { fg = "#ff6c6b" })
hl("@tag.attribute", { fg = "#c678dd" })
hl("@tag.delimiter", { fg = "#bbc2cf" })
hl("@namespace", { fg = "#ecbe7b" })
hl("@module", { fg = "#ecbe7b" })

-- diagnostics
hl("DiagnosticError", { fg = "#ff6c6b" })
hl("DiagnosticWarn", { fg = "#ecbe7b" })
hl("DiagnosticInfo", { fg = "#51afef" })
hl("DiagnosticHint", { fg = "#46d9ff" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#ff6c6b" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#ecbe7b" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#51afef" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#46d9ff" })

-- diff / git
hl("DiffAdd", { fg = "#98be65", bg = "#21242b" })
hl("DiffChange", { fg = "#ecbe7b", bg = "#21242b" })
hl("DiffDelete", { fg = "#ff6c6b", bg = "#21242b" })
hl("DiffText", { fg = "#51afef", bg = "#21242b" })
hl("GitSignsAdd", { fg = "#98be65" })
hl("GitSignsChange", { fg = "#ecbe7b" })
hl("GitSignsDelete", { fg = "#ff6c6b" })
