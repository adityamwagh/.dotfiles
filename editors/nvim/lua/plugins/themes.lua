return {
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("pierre-dark-soft")
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("pierre-light-soft")
            end,
        },
    },
}
