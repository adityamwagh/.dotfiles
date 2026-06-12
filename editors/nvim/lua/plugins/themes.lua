return {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    { "folke/tokyonight.nvim", priority = 1000 },
    { "Shatur/neovim-ayu", priority = 1000 },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("vscode-2026-dark")
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("pierre-light")
            end,
        },
    },
}
