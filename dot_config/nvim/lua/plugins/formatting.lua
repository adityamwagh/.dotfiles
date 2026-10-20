return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    cpp = { "clang-tidy" },
                    -- Python formatting is handled by the ruff language server
                    -- (see lsp.lua); conform falls back to LSP formatting.
                    python = {},
                },
                format_on_save = {
                    lsp_format = "fallback",
                    async = false,
                    timeout_ms = 500,
                },
            })
            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                require("conform").format()
            end, { desc = "Format file or range" })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                -- Python linting is handled by the ruff language server (see lsp.lua).
                lua = { "selene" },
            }
        end,
    },
}
