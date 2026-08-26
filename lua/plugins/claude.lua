return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal_cmd = "~/.local/bin/claude", -- Point to local installation
    terminal = {
      -- A TUI do Claude redesenha a tela continuamente (spinner + streaming).
      -- Dentro de um :terminal isso vira uma enxurrada de eventos de redraw no
      -- canal RPC e o cliente TUI do Neovim acaba parando de pintar — a tela
      -- congela enquanto servidor e Claude seguem vivos.
      -- Rodando por fora, o Neovim mantém só o servidor MCP: Send, Add, diffs
      -- e o Neo-tree continuam funcionando.
      provider = "external",
      provider_opts = {
        -- Retornar tabela => o plugin usa como argv direto, sem shell-split.
        --   -u  : desativa o DBus. Sem isso o Terminator reaproveita a instância
        --         já aberta e a nova aba herdaria o ambiente DELA, perdendo
        --         CLAUDE_CODE_SSE_PORT / ENABLE_IDE_INTEGRATION.
        --   -x  : usa o resto dos argumentos como o comando a executar.
        --   sh -c: expande o "~" de terminal_cmd e os args (--resume, --continue).
        external_terminal_cmd = function(cmd, _env)
          return {
            "terminator",
            "-u",
            "--working-directory=" .. vim.fn.getcwd(),
            "-x",
            "sh",
            "-c",
            cmd,
          }
        end,
      },
    },
  },
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
