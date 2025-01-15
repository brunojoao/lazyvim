return {
  "akinsho/git-conflict.nvim",
  version = "v2.1.0",
  lazy = false,
  config = function()
    require("git-conflict").setup({
      default_mappings = false,
    })
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "Git Conflict" }
    map(
      "n",
      "<leader>gw",
      ":GitConflictChooseOurs<CR>",
      vim.tbl_extend("force", opts, { desc = "GitConflict - Escolher mudanças nossas" })
    )
    map(
      "n",
      "<leader>gt",
      ":GitConflictChooseTheirs<CR>",
      vim.tbl_extend("force", opts, { desc = "GitConflict - Escolher mudanças deles" })
    )
    map(
      "n",
      "<leader>ga",
      ":GitConflictChooseBoth<CR>",
      vim.tbl_extend("force", opts, { desc = "GitConflict - Escolher ambas mudanças" })
    )
    map(
      "n",
      "<leader>gn",
      ":GitConflictChooseNone<CR>",
      vim.tbl_extend("force", opts, { desc = "GitConflict - Escolher nenhuma mudança" })
    )
    map("n", "]x", ":GitConflictNextConflict<CR>", vim.tbl_extend("force", opts, { desc = "Próximo conflito" }))
    map("n", "[x", ":GitConflictPrevConflict<CR>", vim.tbl_extend("force", opts, { desc = "Conflito anterior" }))
    map(
      "n",
      "<leader>gq",
      ":GitConflictListQf<CR>",
      vim.tbl_extend("force", opts, { desc = "GitConflict - Listar conflitos no quickfix" })
    )
  end,
}
