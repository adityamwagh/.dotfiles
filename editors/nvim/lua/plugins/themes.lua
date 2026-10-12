return {
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        lazy = false,
        priority = 1000,
    },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("github_dark_default") -- GitHub Dark Default colorscheme.
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("github_light_default") -- GitHub Light Default colorscheme.
            end,
        },
    },
}
