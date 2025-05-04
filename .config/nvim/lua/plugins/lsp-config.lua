return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
      },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer" },
      })

      require("mason-lspconfig").setup_handlers({

        function(server_name) -- default handler
          require("lspconfig")[server_name].setup({})
        end,

        ["rust_analyzer"] = function() end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Setup lua
      --require("plugins.lsp.lsp-lua")
      --require("plugins.lsp.lsp-rust")
    end,
  },
}
