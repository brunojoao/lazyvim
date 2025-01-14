return {
  "akinsho/git-conflict.nvim",
  version = "v2.1.0",
  lazy = false,
  config = function()
    require("git-conflict").setup({
      default_mappings = false,
    })
  end,
}
