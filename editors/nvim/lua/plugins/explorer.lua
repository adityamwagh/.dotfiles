return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
        },
        opts = {
            disable_netrw = true, -- let nvim-tree own directory buffers
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
            update_focused_file = { enable = true }, -- reveal the file you are editing
            view = { width = 35 },
            filters = {
                dotfiles = false, -- show dotfiles
            },
            renderer = { group_empty = true },
        },
        init = function()
            local nvimtree = "NvimTree_"

            -- Open the tree on startup when launched on a directory (e.g. `nvim .`),
            -- whether a session was restored or not. VeryLazy fires after both the
            -- session layout and plugin setup have settled. `startup_dir` is set
            -- in core/options.lua because session restore clears the arg list.
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                once = true,
                callback = function()
                    if not vim.g.startup_dir then
                        return
                    end
                    pcall(function()
                        require("nvim-tree.api").tree.open()
                    end)
                    -- Leave focus in the editor, not the tree, so `:q` exits.
                    vim.schedule(function()
                        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                            local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                            if ft ~= "NvimTree" then
                                vim.api.nvim_set_current_win(win)
                                return
                            end
                        end
                    end)
                end,
            })

            -- Quit when the tree is the only window left, so a single `:q` in the
            -- editor exits Neovim instead of stopping at the sidebar.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
                pattern = nvimtree .. "*",
                callback = function()
                    if vim.fn.winnr("$") == 1 and vim.bo.filetype == "NvimTree" then
                        vim.cmd("quit")
                    end
                end,
            })

            -- If `:q` would leave no editor window, close Neovim entirely so a
            -- single `:q` exits instead of stopping at the sidebar. WinClosed is
            -- used rather than QuitPre, which nests badly and blocks VimLeavePre.
            vim.api.nvim_create_autocmd("WinClosed", {
                group = vim.api.nvim_create_augroup("NvimTreeWinClosed", { clear = true }),
                callback = function()
                    -- Never interfere while Neovim is exiting or a save is running.
                    if vim.v.exiting ~= "" or vim.g.SessionSaveInProgress then
                        return
                    end
                    vim.schedule(function()
                        if vim.v.exiting ~= "" or vim.g.SessionSaveInProgress then
                            return
                        end
                        if vim.fn.winnr("$") ~= 1 then
                            return
                        end
                        local ft =
                            vim.bo[vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())].filetype
                        if ft == "NvimTree" then
                            vim.cmd("quitall")
                        end
                    end)
                end,
            })
        end,
    },
}
