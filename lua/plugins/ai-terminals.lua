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
            -- Tenta pegar do ambiente atual
            local key = vim.env.GEMINI_API_KEY

            -- Se estiver vazio, vamos tentar extrair direto do .bashrc via shell
            if not key or key == "" then
              key = vim.fn.system("source ~/.bashrc && echo -n $GEMINI_API_KEY")
            end

            local base_cmd = "aider --model gemini/gemini-1.5-flash-latest --watch-files"

            if key and key ~= "" then
              -- Exportamos ambas para não ter erro de versão do Aider
              return string.format("export GEMINI_API_KEY=%s GOOGLE_API_KEY=%s && %s", key, key, base_cmd)
            else
              -- Se nem assim achar, retorna o base pra você ver o erro do Aider
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
