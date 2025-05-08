return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua_ls",
          "stylua",
          "vimls",
          "rust_analyzer",
          "codelldb",
          "bash-language-server",
          "shfmt",
        },

        auto_update = true
      })
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp-configs.lua-lsp")
    end
  }
}
