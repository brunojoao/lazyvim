-- lua/plugins/ai-terminals.lua
return {
  {
    "aweis89/ai-terminals.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Optional: customize commands and per-terminal formatting
      terminals = {
        aider = {
          cmd = function()
            local gemini_api_key = vim.env.GEMINI_API_KEY
            local base_cmd = "aider --model gemini/gemini-2.5-pro --watch-files"
            if gemini_api_key then
              return "GEMINI_API_KEY=" .. gemini_api_key .. " " .. base_cmd
            else
              -- Se a variável GEMINI_API_KEY não estiver definida em vim.env,
              -- o comando será executado sem ela explicitamente definida aqui,
              -- contando com a herança do ambiente do shell.
              return base_cmd
            end
          end,
          path_header_template = "`%s`",
        },
      },
      -- One line to get consistent mappings for all terminals
      auto_terminal_keymaps = {
        prefix = "<leader>a",
        terminals = {
          { name = "aider", key = "a" },
          -- { name = "cursor", key = "r", enabled = false }, -- example disabled
        },
      },
    },
    config = function(_, opts)
      require("ai-terminals").setup(opts)
      -- Optional: integrate Snacks pickers with add-file actions
      local sa = require("ai-terminals.snacks_actions")
      sa.apply(require("snacks").config) -- merges actions + safe default picker keys
    end,
  },
}
