-- lua/plugins/ai-terminals.lua
return {
  {
    "aweis89/ai-terminals.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Optional: customize commands and per-terminal formatting
      terminals = {
        claude = {
          cmd = function()
            return "claude"
          end,
        },
        aider = {
          cmd = function()
            return "aider --watch-files"
          end,
          path_header_template = "`%s`",
        },
      },
      -- One line to get consistent mappings for all terminals
      auto_terminal_keymaps = {
        prefix = "<leader>a",
        terminals = {
          { name = "claude", key = "c" },
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
