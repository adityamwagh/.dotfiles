return {
  {
    "leonardcser/cursortab.nvim",
    build = "cd server && go build",
    config = function()
      require("cursortab").setup({
        provider = {
          type = "sweep",
          url = "http://localhost:8000",
          model = "sweep-next-edit-1.5b",
          temperature = 0.0, -- Sampling temperature
          max_tokens = 4096, -- Max tokens to generate
          top_k = 50, -- Top-k sampling
          completion_timeout = 10000, -- Timeout in ms for completion requests
          max_diff_history_tokens = 512, -- Max tokens for diff history (0 = no limit)
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
