return {
  {
    "nvimtools/none-ls.nvim",
  },
  {
    "jay-babu/mason-null-ls.nvim",
    config = function()
      require("mason-null-ls").setup({
        handlers = {},
      })
    end,
  }
}
