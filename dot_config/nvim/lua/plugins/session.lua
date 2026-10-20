return {
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            auto_restore = true, -- restore the session for the current directory on start
            auto_save = true, -- save the session on exit
            args_allow_single_directory = true, -- treat `nvim .` / `nvim ~/proj` as a project root
            close_unsupported_windows = true, -- don't save the file tree window
            suppressed_dirs = { "~/", "~/Downloads", "/" },
            pre_save_cmds = {
                function()
                    -- Keep the tree autocmds from reacting while the session is saved.
                    vim.g.SessionSaveInProgress = true
                end,
            },
            post_save_cmds = {
                function()
                    vim.g.SessionSaveInProgress = false
                end,
            },
            no_restore_cmds = {
                function()
                    -- No saved session: `nvim .` still gets a tree beside an empty
                    -- buffer, and the directory buffer is dropped so one `:q` exits.
                    -- The tree and focus are handled on VeryLazy in explorer.lua.
                    if vim.g.startup_dir then
                        local dir_buf = vim.fn.bufnr(vim.g.startup_dir)
                        vim.cmd("enew")
                        vim.schedule(function()
                            if dir_buf > 0 and vim.api.nvim_buf_is_valid(dir_buf) then
                                vim.api.nvim_buf_delete(dir_buf, { force = true })
                            end
                        end)
                    end
                end,
            },
        },
        keys = {
            {
                "<leader>qs",
                function()
                    require("auto-session").RestoreSession()
                end,
                desc = "Restore session",
            },
            {
                "<leader>qS",
                function()
                    require("auto-session").SelectSession()
                end,
                desc = "Select session",
            },
            {
                "<leader>ql",
                function()
                    require("auto-session").RestoreSessionForCwd()
                end,
                desc = "Restore session for cwd",
            },
            {
                "<leader>qd",
                function()
                    require("auto-session").DeleteSession()
                end,
                desc = "Delete session",
            },
            {
                "<leader>qD",
                function()
                    require("auto-session").PurgeDeletedSession()
                end,
                desc = "Purge deleted sessions",
            },
        },
    },
}
