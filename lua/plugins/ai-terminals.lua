return {
  "aweis89/ai-terminals.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    auto_terminal_keymaps = {
      prefix = "<leader>a",
      terminals = {
        { name = "claude", key = "c" },
        { name = "aider", key = "a" },
      },
    },
  },
}
