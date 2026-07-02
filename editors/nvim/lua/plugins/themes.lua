return {
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("eccentric-dark") -- Local Eccentric Dark colorscheme.
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("eccentric-light") -- Local Eccentric Light colorscheme.
            end,
        },
    },
}
