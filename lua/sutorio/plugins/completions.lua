return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      -- Snippets plugin. Note that this only makes snippets work, it doesn't
      -- actually provide any snippets itself.
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      -- Always had issues with SQL stuff in NVim, so testing out dadbod:
      "kristijanhusak/vim-dadbod-completion",
      -- REVIEW: testing out Supermaven rather than Copilot
      { "supermaven-inc/supermaven-nvim" },
      -- TODO: THIS IS THROWING ERRORS "zbirenbaum/copilot-cmp",
      -- Icons for completion popups
      "onsails/lspkind.nvim",
    },
  },
}
