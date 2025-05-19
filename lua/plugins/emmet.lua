return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "emmet-ls", -- Garante que o emmet-ls está instalado via Mason
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Configuração específica do emmet-ls para PHP
      setup = {
        emmet_ls = function()
          local lspconfig = require("lspconfig")
          lspconfig.emmet_ls.setup({
            filetypes = { "html", "css", "javascript", "javascriptreact", "typescriptreact", "php" }, -- Adicione 'php' aqui
            init_options = {
              --- @type table<string, any> https://github.com/emmetio/emmet/blob/master/src/config.ts#L79
              preferences = {},
              --- @type "always" | "never" defaults to "always"
              showexpandedabbreviation = "always",
              --- @type boolean defaults to false
              showabbreviationsuggestions = true,
              --- @type boolean defaults to false
              triggersuggestions = true,
              --- @type table<string, any> https://github.com/emmetio/emmet/blob/master/src/snippets.ts#L68
              snippets = {},
            },
          })
        end,
      },
    },
  },
}
