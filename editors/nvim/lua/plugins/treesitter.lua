return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        ensure_installed = {
            "lua",
            "vim",
            "vimdoc",
            "query",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
    main = "nvim-treesitter",
}
