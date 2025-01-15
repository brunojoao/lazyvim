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
      "<leader>go",
      ":GitConflictChooseOurs<CR>",
      vim.tbl_extend("force", opts, { desc = "Escolher mudanças nossas" })
    )
    map(
      "n",
      "<leader>gt",
      ":GitConflictChooseTheirs<CR>",
      vim.tbl_extend("force", opts, { desc = "Escolher mudanças deles" })
    )
    map(
      "n",
      "<leader>ga",
      ":GitConflictChooseBoth<CR>",
      vim.tbl_extend("force", opts, { desc = "Escolher ambas mudanças" })
    )
    map(
      "n",
      "<leader>gn",
      ":GitConflictChooseNone<CR>",
      vim.tbl_extend("force", opts, { desc = "Escolher nenhuma mudança" })
    )
    map("n", "]x", ":GitConflictNextConflict<CR>", vim.tbl_extend("force", opts, { desc = "Próximo conflito" }))
    map("n", "[x", ":GitConflictPrevConflict<CR>", vim.tbl_extend("force", opts, { desc = "Conflito anterior" }))
    map(
      "n",
      "<leader>gq",
      ":GitConflictListQf<CR>",
      vim.tbl_extend("force", opts, { desc = "Listar conflitos no quickfix" })
    )
  end,
}
