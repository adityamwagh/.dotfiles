vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "doom-one-light"
vim.o.background = "light"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#383a42"
vim.g.terminal_color_1 = "#e45649"
vim.g.terminal_color_2 = "#50a14f"
vim.g.terminal_color_3 = "#986801"
vim.g.terminal_color_4 = "#4078f2"
vim.g.terminal_color_5 = "#a626a4"
vim.g.terminal_color_6 = "#0184bc"
vim.g.terminal_color_7 = "#a0a1a7"
vim.g.terminal_color_8 = "#696c77"
vim.g.terminal_color_9 = "#e45649"
vim.g.terminal_color_10 = "#50a14f"
vim.g.terminal_color_11 = "#986801"
vim.g.terminal_color_12 = "#4078f2"
vim.g.terminal_color_13 = "#a626a4"
vim.g.terminal_color_14 = "#0184bc"
vim.g.terminal_color_15 = "#383a42"

-- base UI
hl("Normal", { fg = "#383a42", bg = "#fafafa" })
hl("NormalFloat", { fg = "#383a42", bg = "#f0f0f0" })
hl("NormalNC", { fg = "#383a42", bg = "#fafafa" })
hl("FloatBorder", { fg = "#9ca0a4", bg = "#f0f0f0" })
hl("Cursor", { fg = "#fafafa", bg = "#4078f2" })
hl("CursorLine", { bg = "#f0f0f0" })
hl("CursorLineNr", { fg = "#383a42", bold = true })
hl("LineNr", { fg = "#9ca0a4" })
hl("SignColumn", { bg = "#fafafa" })
hl("ColorColumn", { bg = "#f0f0f0" })
hl("Visual", { bg = "#dfdfdf" })
hl("Search", { fg = "#383a42", bg = "#ecbe7b" })
hl("IncSearch", { fg = "#383a42", bg = "#da8548" })
hl("Pmenu", { fg = "#383a42", bg = "#f0f0f0" })
hl("PmenuSel", { fg = "#fafafa", bg = "#4078f2" })
hl("PmenuSbar", { bg = "#f0f0f0" })
hl("PmenuThumb", { bg = "#c6c7c7" })
hl("StatusLine", { fg = "#383a42", bg = "#e7e7e7" })
hl("StatusLineNC", { fg = "#9ca0a4", bg = "#fafafa" })
hl("TabLine", { fg = "#9ca0a4", bg = "#e7e7e7" })
hl("TabLineSel", { fg = "#383a42", bg = "#fafafa" })
hl("TabLineFill", { bg = "#e7e7e7" })
hl("WinSeparator", { fg = "#dfdfdf" })
hl("VertSplit", { fg = "#dfdfdf" })
hl("Folded", { fg = "#9ca0a4", bg = "#f0f0f0" })
hl("FoldColumn", { fg = "#9ca0a4", bg = "#fafafa" })
hl("MatchParen", { fg = "#4078f2", bold = true })
hl("NonText", { fg = "#c6c7c7" })
hl("Whitespace", { fg = "#c6c7c7" })
hl("EndOfBuffer", { fg = "#fafafa" })
hl("WildMenu", { fg = "#fafafa", bg = "#4078f2" })

-- syntax
hl("Comment", { fg = "#7d8083", italic = true })
hl("Constant", { fg = "#b751b6" })
hl("String", { fg = "#50a14f" })
hl("Character", { fg = "#50a14f" })
hl("Number", { fg = "#da8548" })
hl("Float", { fg = "#da8548" })
hl("Boolean", { fg = "#da8548" })
hl("Identifier", { fg = "#6a1869" })
hl("Function", { fg = "#a626a4" })
hl("Statement", { fg = "#4078f2" })
hl("Keyword", { fg = "#4078f2" })
hl("Conditional", { fg = "#4078f2" })
hl("Repeat", { fg = "#4078f2" })
hl("Operator", { fg = "#4078f2" })
hl("Exception", { fg = "#4078f2" })
hl("PreProc", { fg = "#4078f2" })
hl("Include", { fg = "#4078f2" })
hl("Define", { fg = "#4078f2" })
hl("Macro", { fg = "#4078f2" })
hl("Type", { fg = "#986801" })
hl("StorageClass", { fg = "#4078f2" })
hl("Structure", { fg = "#986801" })
hl("Typedef", { fg = "#986801" })
hl("Special", { fg = "#0184bc" })
hl("SpecialChar", { fg = "#0184bc" })
hl("Tag", { fg = "#e45649" })
hl("Delimiter", { fg = "#383a42" })
hl("SpecialComment", { fg = "#005478" })
hl("Error", { fg = "#e45649", bold = true })
hl("Todo", { fg = "#986801", bold = true })
hl("Underlined", { fg = "#4078f2", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#0184bc" })
hl("@string.special", { fg = "#0184bc" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#b751b6" })
hl("@constant.builtin", { fg = "#b751b6" })
hl("@variable", { fg = "#6a1869" })
hl("@variable.builtin", { fg = "#e45649" })
hl("@variable.member", { fg = "#6a1869" })
hl("@variable.parameter", { fg = "#383a42" })
hl("@function", { fg = "#a626a4" })
hl("@function.builtin", { fg = "#a626a4" })
hl("@function.call", { fg = "#a626a4" })
hl("@function.method", { fg = "#0184bc" })
hl("@function.method.call", { fg = "#0184bc" })
hl("@type", { fg = "#986801" })
hl("@type.builtin", { fg = "#986801" })
hl("@type.definition", { fg = "#986801" })
hl("@attribute", { fg = "#b751b6" })
hl("@property", { fg = "#6a1869" })
hl("@field", { fg = "#6a1869" })
hl("@constructor", { fg = "#986801" })
hl("@operator", { fg = "#4078f2" })
hl("@punctuation.bracket", { fg = "#383a42" })
hl("@punctuation.delimiter", { fg = "#383a42" })
hl("@tag", { fg = "#e45649" })
hl("@tag.attribute", { fg = "#a626a4" })
hl("@tag.delimiter", { fg = "#383a42" })
hl("@namespace", { fg = "#986801" })
hl("@module", { fg = "#986801" })

-- diagnostics
hl("DiagnosticError", { fg = "#e45649" })
hl("DiagnosticWarn", { fg = "#986801" })
hl("DiagnosticInfo", { fg = "#4078f2" })
hl("DiagnosticHint", { fg = "#0184bc" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#e45649" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#986801" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#4078f2" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#0184bc" })

-- diff / git
hl("DiffAdd", { fg = "#50a14f", bg = "#f0f0f0" })
hl("DiffChange", { fg = "#986801", bg = "#f0f0f0" })
hl("DiffDelete", { fg = "#e45649", bg = "#f0f0f0" })
hl("DiffText", { fg = "#4078f2", bg = "#f0f0f0" })
hl("GitSignsAdd", { fg = "#50a14f" })
hl("GitSignsChange", { fg = "#986801" })
hl("GitSignsDelete", { fg = "#e45649" })
