local map = vim.keymap.set

-- Detect OS
local is_mac = vim.fn.has("macunix") == 1
local toggle_key = is_mac and "<D-/>" or "<C-_>"

-- Ctrl+A: Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("v", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Comment with gc + motion (vim way)
-- gcc = comment current line
-- gc2j = comment current line + 2 lines down
-- gcip = comment inner paragraph
-- gcG = comment from here to end of file

-- VS Code style Ctrl+/ shortcuts
map("n", toggle_key, "gcc", { desc = "Toggle comment", remap = true })
map("x", toggle_key, "gc", { desc = "Toggle comment", remap = true })
map("i", toggle_key, "<Esc>gcca", { desc = "Toggle comment", remap = true })
