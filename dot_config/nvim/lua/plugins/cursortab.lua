return {
    {
        "cursortab/cursortab.nvim",
        -- Pinned to v0.7.8: v0.8.0 made provider.fim_tokens optional but left it
        -- out of the default config, so the key validator rejects it (upstream
        -- regression in 94dd642). Revisit once a release accepts fim_tokens again.
        version = "v0.7.8",
        -- The Go server is built on install; lazy.nvim already lazy-loads it.
        build = "cd server && go build",
        config = function()
            require("cursortab").setup({
                provider = {
                    -- DeepSeek FIM completions (beta endpoint). v0.7.8 always
                    -- tokenizes FIM, so use DeepSeek's unicode markers.
                    -- Key comes from $DEEPSEEK_API_KEY (see ~/.env).
                    type = "fim",
                    url = "https://api.deepseek.com/beta",
                    model = "deepseek-flash",
                    api_key_env = "DEEPSEEK_API_KEY",
                    fim_tokens = {
                        prefix = "⸤", -- U+2E24
                        suffix = "⸥", -- U+2E25
                        middle = "⸦", -- U+2E26
                    },
                },
            })
        end,
    },
}
