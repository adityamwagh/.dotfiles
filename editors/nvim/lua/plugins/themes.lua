return {
    {
        "NTBBloodbath/doom-one.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.doom_one_terminal_colors = true -- Apply the palette to :terminal.
            vim.g.doom_one_enable_treesitter = true -- Use Tree-sitter highlight groups.
            vim.g.doom_one_italic_comments = false -- No italic comments.
        end,
    },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("revontuli") -- Local Revontuli dark colorscheme.
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("pierre-light-soft") -- Pierre Light Soft for light appearance.
            end,
        },
    },
}
