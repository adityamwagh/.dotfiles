vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "pierre-light"
vim.o.background = "light"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#1d1d1d"
vim.g.terminal_color_1 = "#d52c36"
vim.g.terminal_color_2 = "#18a46c"
vim.g.terminal_color_3 = "#d5a910"
vim.g.terminal_color_4 = "#1a85d4"
vim.g.terminal_color_5 = "#bd2e90"
vim.g.terminal_color_6 = "#1ca1c7"
vim.g.terminal_color_7 = "#bcbcbc"
vim.g.terminal_color_8 = "#1d1d1d"
vim.g.terminal_color_9 = "#d52c36"
vim.g.terminal_color_10 = "#77a42a"
vim.g.terminal_color_11 = "#d5a910"
vim.g.terminal_color_12 = "#1a85d4"
vim.g.terminal_color_13 = "#bd2e90"
vim.g.terminal_color_14 = "#1ca1c7"
vim.g.terminal_color_15 = "#bcbcbc"

-- base UI
hl("Normal", { fg = "#0a0a0a", bg = "#ffffff" })
hl("NormalFloat", { fg = "#0a0a0a", bg = "#f7f7f7" })
hl("NormalNC", { fg = "#525252", bg = "#ffffff" })
hl("FloatBorder", { fg = "#737373", bg = "#f7f7f7" })
hl("Cursor", { fg = "#ffffff", bg = "#009fff" })
hl("CursorLine", { bg = "#f7f7f7" })
hl("CursorLineNr", { fg = "#0a0a0a", bold = true })
hl("LineNr", { fg = "#8a8a8a" })
hl("SignColumn", { bg = "#ffffff" })
hl("ColorColumn", { bg = "#f7f7f7" })
hl("Visual", { bg = "#dfebff" })
hl("Search", { fg = "#0a0a0a", bg = "#ffde80" })
hl("IncSearch", { fg = "#0a0a0a", bg = "#ffba82" })
hl("Pmenu", { fg = "#0a0a0a", bg = "#f7f7f7" })
hl("PmenuSel", { fg = "#ffffff", bg = "#009fff" })
hl("PmenuSbar", { bg = "#f7f7f7" })
hl("PmenuThumb", { bg = "#8a8a8a" })
hl("StatusLine", { fg = "#404040", bg = "#f5f5f5" })
hl("StatusLineNC", { fg = "#737373", bg = "#ffffff" })
hl("TabLine", { fg = "#737373", bg = "#f5f5f5" })
hl("TabLineSel", { fg = "#0a0a0a", bg = "#ffffff" })
hl("TabLineFill", { bg = "#f5f5f5" })
hl("WinSeparator", { fg = "#d4d4d4" })
hl("VertSplit", { fg = "#d4d4d4" })
hl("Folded", { fg = "#737373", bg = "#f7f7f7" })
hl("FoldColumn", { fg = "#8a8a8a", bg = "#ffffff" })
hl("MatchParen", { fg = "#009fff", bold = true })
hl("NonText", { fg = "#bcbcbc" })
hl("Whitespace", { fg = "#bcbcbc" })
hl("EndOfBuffer", { fg = "#ffffff" })
hl("WildMenu", { fg = "#ffffff", bg = "#009fff" })

-- syntax
hl("Comment", { fg = "#737373", italic = true })
hl("Constant", { fg = "#d5a910" })
hl("String", { fg = "#199f43" })
hl("Character", { fg = "#199f43" })
hl("Number", { fg = "#1ca1c7" })
hl("Float", { fg = "#1ca1c7" })
hl("Boolean", { fg = "#1ca1c7" })
hl("Identifier", { fg = "#d47628" })
hl("Function", { fg = "#693acf" })
hl("Statement", { fg = "#d32a61" })
hl("Keyword", { fg = "#d32a61" })
hl("Conditional", { fg = "#d32a61" })
hl("Repeat", { fg = "#d32a61" })
hl("Operator", { fg = "#08c0ef" })
hl("Exception", { fg = "#d32a61" })
hl("PreProc", { fg = "#d32a61" })
hl("Include", { fg = "#d32a61" })
hl("Define", { fg = "#d32a61" })
hl("Macro", { fg = "#d32a61" })
hl("Type", { fg = "#a631be" })
hl("StorageClass", { fg = "#d32a61" })
hl("Structure", { fg = "#a631be" })
hl("Typedef", { fg = "#a631be" })
hl("Special", { fg = "#16a994" })
hl("SpecialChar", { fg = "#16a994" })
hl("Tag", { fg = "#d5512f" })
hl("Delimiter", { fg = "#636363" })
hl("SpecialComment", { fg = "#737373" })
hl("Error", { fg = "#d52c36", bold = true })
hl("Todo", { fg = "#d5901c", bold = true })
hl("Underlined", { fg = "#009fff", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { link = "Keyword" })
hl("@keyword.operator", { link = "Keyword" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#16a994" })
hl("@string.special", { fg = "#17a5af" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#d5a910" })
hl("@constant.builtin", { fg = "#d5a910" })
hl("@variable", { fg = "#d47628" })
hl("@variable.builtin", { fg = "#d5901c" })
hl("@variable.member", { fg = "#d47628" })
hl("@variable.parameter", { fg = "#636363" })
hl("@function", { fg = "#693acf" })
hl("@function.builtin", { fg = "#693acf" })
hl("@function.call", { fg = "#693acf" })
hl("@function.method", { fg = "#693acf" })
hl("@function.method.call", { fg = "#693acf" })
hl("@type", { fg = "#a631be" })
hl("@type.builtin", { fg = "#a631be" })
hl("@type.definition", { fg = "#a631be" })
hl("@attribute", { fg = "#1a85d4" })
hl("@property", { fg = "#d47628" })
hl("@field", { fg = "#d47628" })
hl("@constructor", { fg = "#a631be" })
hl("@operator", { fg = "#08c0ef" })
hl("@punctuation.bracket", { fg = "#636363" })
hl("@punctuation.delimiter", { fg = "#636363" })
hl("@tag", { fg = "#d5512f" })
hl("@tag.attribute", { fg = "#18a46c" })
hl("@tag.delimiter", { fg = "#636363" })
hl("@namespace", { fg = "#d5901c" })
hl("@module", { fg = "#d5901c" })

-- diagnostics
hl("DiagnosticError", { fg = "#d52c36" })
hl("DiagnosticWarn", { fg = "#d5a910" })
hl("DiagnosticInfo", { fg = "#1ca1c7" })
hl("DiagnosticHint", { fg = "#1a85d4" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#d52c36" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#d5a910" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#1ca1c7" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#1a85d4" })

-- diff / git
hl("DiffAdd", { fg = "#18a46c", bg = "#f7f7f7" })
hl("DiffChange", { fg = "#d5a910", bg = "#f7f7f7" })
hl("DiffDelete", { fg = "#d52c36", bg = "#f7f7f7" })
hl("DiffText", { fg = "#1a85d4", bg = "#f7f7f7" })
hl("GitSignsAdd", { fg = "#18a46c" })
hl("GitSignsChange", { fg = "#d5a910" })
hl("GitSignsDelete", { fg = "#d52c36" })
