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
                    -- Sweep next-edit completions from the local llama.cpp
                    -- server (see systemd/sweep-next-edit.service).
                    type = "sweep",
                    url = "http://127.0.0.1:8002",
                    model = "sweep-next-edit-v2-7B",
                },
            })
        end,
    },
}