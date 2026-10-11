return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                clangd = { cmd = { "clangd", "--background-index", "--clang-tidy" } },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } },
                            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        },
                    },
                },
                ruff = { cmd = { "ruff", "server" } },
                rust_analyzer = {},
                ty = { cmd = { "ty", "server" } },
            }

            for name, opts in pairs(servers) do
                opts.capabilities = capabilities
                vim.lsp.config(name, opts)
                vim.lsp.enable(name)
            end
        end,
    },
}
