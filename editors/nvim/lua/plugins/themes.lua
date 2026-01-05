return {
    { "catppuccin/nvim",         name = "catppuccin", priority = 1000 },
    { "neanias/everforest-nvim", priority = 1000 },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "light",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("everforest")
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("catppuccin-latte")
            end,
        },
    },
}
