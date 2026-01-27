return {
  require("plugins.lsp"),
  require("plugins.completions"),
  require("plugins.themes"),
  require("plugins.formatting"),
  require("plugins.comments"),
  require("plugins.ui"),
  { "nvim-lua/plenary.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   config = function()
  --     require("codecompanion").setup()
  --   end,
  -- },
}
