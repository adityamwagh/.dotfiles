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
                    -- FIM completions from the local llama.cpp server
                    -- (see systemd/llama-fim.service).
                    type = "fim",
                    url = "http://127.0.0.1:8000",
                    model = "qwen2.5-coder-1.5b",
                    -- Qwen FIM tokens; repo_name/file_sep enable cross-file context.
                    fim_tokens = {
                        prefix = "<|fim_prefix|>",
                        suffix = "<|fim_suffix|>",
                        middle = "<|fim_middle|>",
                        repo_name = "<|repo_name|>",
                        file_sep = "<|file_sep|>",
                    },
                },
            })
        end,
    },
}