vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "revontuli-light"
vim.o.background = "light"

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- terminal colors
vim.g.terminal_color_0 = "#909090"
vim.g.terminal_color_1 = "#c82835"
vim.g.terminal_color_2 = "#4bc828"
vim.g.terminal_color_3 = "#c87028"
vim.g.terminal_color_4 = "#2885c8"
vim.g.terminal_color_5 = "#be62df"
vim.g.terminal_color_6 = "#28c8c8"
vim.g.terminal_color_7 = "#000000"
vim.g.terminal_color_8 = "#656066"
vim.g.terminal_color_9 = "#c82835"
vim.g.terminal_color_10 = "#4bc828"
vim.g.terminal_color_11 = "#c87028"
vim.g.terminal_color_12 = "#2885c8"
vim.g.terminal_color_13 = "#be62df"
vim.g.terminal_color_14 = "#28c8c8"
vim.g.terminal_color_15 = "#000000"

-- base UI
hl("Normal", { fg = "#000000", bg = "#f2f2f2" })
hl("NormalFloat", { fg = "#000000", bg = "#e0dce0" })
hl("NormalNC", { fg = "#474247", bg = "#f2f2f2" })
hl("FloatBorder", { fg = "#909090", bg = "#e0dce0" })
hl("Cursor", { fg = "#f2f2f2", bg = "#28c87d" })
hl("CursorLine", { bg = "#e0dce0" })
hl("CursorLineNr", { fg = "#28c87d", bold = true })
hl("LineNr", { fg = "#847e85" })
hl("SignColumn", { bg = "#f2f2f2" })
hl("ColorColumn", { bg = "#e0dce0" })
hl("Visual", { bg = "#bcd4ef" })
hl("Search", { fg = "#000000", bg = "#28c87d" })
hl("IncSearch", { fg = "#000000", bg = "#28c8c8" })
hl("Pmenu", { fg = "#000000", bg = "#e0dce0" })
hl("PmenuSel", { fg = "#f2f2f2", bg = "#2885c8" })
hl("PmenuSbar", { bg = "#e0dce0" })
hl("PmenuThumb", { bg = "#909090" })
hl("StatusLine", { fg = "#000000", bg = "#d9d9d9" })
hl("StatusLineNC", { fg = "#474247", bg = "#f2f2f2" })
hl("TabLine", { fg = "#474247", bg = "#e0dce0" })
hl("TabLineSel", { fg = "#000000", bg = "#f2f2f2" })
hl("TabLineFill", { bg = "#e0dce0" })
hl("WinSeparator", { fg = "#b2b2b2" })
hl("VertSplit", { fg = "#b2b2b2" })
hl("Folded", { fg = "#474247", bg = "#e0dce0" })
hl("FoldColumn", { fg = "#909090", bg = "#f2f2f2" })
hl("MatchParen", { fg = "#28c87d", bold = true })
hl("NonText", { fg = "#b2b2b2" })
hl("Whitespace", { fg = "#b2b2b2" })
hl("EndOfBuffer", { fg = "#f2f2f2" })
hl("WildMenu", { fg = "#f2f2f2", bg = "#2885c8" })

-- syntax (Kate canonical, light accents)
hl("Comment", { fg = "#847e85", italic = true })
hl("Constant", { fg = "#28c8c8", bold = true })
hl("String", { fg = "#4bc828" })
hl("Character", { fg = "#2885c8" })
hl("Number", { fg = "#be62df", bold = true })
hl("Float", { fg = "#be62df", bold = true })
hl("Boolean", { fg = "#be62df", bold = true })
hl("Identifier", { fg = "#c87028" })
hl("Function", { fg = "#6770c8", bold = true })
hl("Statement", { fg = "#2885c8" })
hl("Keyword", { fg = "#2885c8", bold = true })
hl("Conditional", { fg = "#28c87d", italic = true })
hl("Repeat", { fg = "#28c87d", italic = true })
hl("Operator", { fg = "#28c87d" })
hl("Exception", { fg = "#28c87d", italic = true })
hl("PreProc", { fg = "#dfc12d", bold = true })
hl("Include", { fg = "#be62df" })
hl("Define", { fg = "#dfc12d", bold = true })
hl("Macro", { fg = "#dfc12d", bold = true })
hl("Type", { fg = "#28c8c8" })
hl("StorageClass", { fg = "#2885c8", bold = true })
hl("Structure", { fg = "#28c8c8" })
hl("Typedef", { fg = "#28c8c8" })
hl("Special", { fg = "#dfc12d" })
hl("SpecialChar", { fg = "#dfc12d", italic = true })
hl("Tag", { fg = "#dfc12d", italic = true })
hl("Delimiter", { fg = "#474247" })
hl("SpecialComment", { fg = "#6770c8", italic = true })
hl("Error", { fg = "#c82835", bold = true })
hl("Todo", { fg = "#dfc12d", bold = true })
hl("Underlined", { fg = "#2885c8", underline = true })

-- treesitter
hl("@comment", { link = "Comment" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.return", { fg = "#28c87d", italic = true })
hl("@keyword.operator", { fg = "#28c87d" })
hl("@keyword.conditional", { fg = "#28c87d", italic = true })
hl("@keyword.repeat", { fg = "#28c87d", italic = true })
hl("@keyword.import", { fg = "#be62df" })
hl("@string", { link = "String" })
hl("@string.escape", { fg = "#dfc12d", italic = true })
hl("@string.special", { fg = "#dfc12d" })
hl("@number", { link = "Number" })
hl("@float", { link = "Float" })
hl("@boolean", { link = "Boolean" })
hl("@constant", { fg = "#28c8c8", bold = true })
hl("@constant.builtin", { fg = "#28c8c8", bold = true })
hl("@variable", { fg = "#c87028" })
hl("@variable.builtin", { fg = "#c82835" })
hl("@variable.member", { fg = "#c87028" })
hl("@variable.parameter", { fg = "#000000" })
hl("@function", { fg = "#6770c8", bold = true })
hl("@function.builtin", { fg = "#6770c8", bold = true })
hl("@function.call", { fg = "#6770c8" })
hl("@function.method", { fg = "#6770c8" })
hl("@function.method.call", { fg = "#6770c8" })
hl("@type", { fg = "#28c8c8" })
hl("@type.builtin", { fg = "#28c8c8" })
hl("@type.definition", { fg = "#28c8c8" })
hl("@attribute", { fg = "#dfc12d", italic = true })
hl("@property", { fg = "#c87028" })
hl("@field", { fg = "#c87028" })
hl("@constructor", { fg = "#28c8c8" })
hl("@operator", { fg = "#28c87d" })
hl("@punctuation.bracket", { fg = "#474247" })
hl("@punctuation.delimiter", { fg = "#474247" })
hl("@tag", { fg = "#2885c8", bold = true })
hl("@tag.attribute", { fg = "#dfc12d", italic = true })
hl("@tag.delimiter", { fg = "#474247" })
hl("@namespace", { fg = "#6770c8" })
hl("@module", { fg = "#6770c8" })

-- diagnostics
hl("DiagnosticError", { fg = "#c82835" })
hl("DiagnosticWarn", { fg = "#c87028" })
hl("DiagnosticInfo", { fg = "#2885c8" })
hl("DiagnosticHint", { fg = "#28c87d" })
hl("DiagnosticUnderlineError", { undercurl = true, sp = "#c82835" })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#c87028" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = "#2885c8" })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = "#28c87d" })

-- diff / git
hl("DiffAdd", { fg = "#4bc828", bg = "#e0dce0" })
hl("DiffChange", { fg = "#c87028", bg = "#e0dce0" })
hl("DiffDelete", { fg = "#c82835", bg = "#e0dce0" })
hl("DiffText", { fg = "#2885c8", bg = "#e0dce0" })
hl("GitSignsAdd", { fg = "#4bc828" })
hl("GitSignsChange", { fg = "#c87028" })
hl("GitSignsDelete", { fg = "#c82835" })
