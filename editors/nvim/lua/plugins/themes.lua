return {
    { "kepano/flexoki-neovim", name = "flexoki" },
    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 100,
            fallback = "dark",
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("flexoki-dark") -- Flexoki Dark colorscheme.
            end,
            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("flexoki-light") -- Flexoki Light colorscheme.
            end,
        },
    },
}
