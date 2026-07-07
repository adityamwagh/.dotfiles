return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        ts.install({ "lua", "vim", "vimdoc", "query" })

        local installed = {}
        for _, lang in ipairs(ts.get_installed()) do
            installed[lang] = true
        end

        local available = {}
        for _, lang in ipairs(require("nvim-treesitter.config").get_available()) do
            available[lang] = true
        end

        local function enable(buf)
            vim.treesitter.start(buf)
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end

                if installed[lang] then
                    enable(buf)
                elseif available[lang] then
                    ts.install(lang):await(function()
                        installed[lang] = true
                        vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(buf) then
                                enable(buf)
                            end
                        end)
                    end)
                end
            end,
        })
    end,
}
