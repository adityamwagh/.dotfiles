return {
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "light",
            set_dark_mode = function()
                vim.opt.background = "dark"
                require("gruvbox").setup({
                    contrast = "hard",
                })
                vim.cmd.colorscheme("gruvbox")
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                require("gruvbox").setup({
                    contrast = "soft",
                })
                vim.cmd.colorscheme("gruvbox")
            end,
        },
    },
}
