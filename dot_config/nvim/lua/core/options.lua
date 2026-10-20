vim.opt.number = true
vim.opt.confirm = true
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.g.mapleader = " "
vim.g.current_theme = "dark"

-- When started on a directory (`nvim .`, `nvim ~/proj`), make it the working
-- directory so tools like the file explorer and fzf-lua use it as the root.
local arg = vim.fn.argv(0)
if vim.fn.argc() == 1 and vim.fn.isdirectory(arg) == 1 then
    vim.fn.chdir(arg)
    -- Remember it: session restore clears the argument list later on.
    vim.g.startup_dir = vim.fn.getcwd()
end
