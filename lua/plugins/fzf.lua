return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      keymap = {
        fzf = {
          ["alt-down"] = "next-history",
          ["alt-up"] = "prev-history",
        },
      },
      files = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
        },
        cwd_prompt = false,
      },
      grep = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
      },
      actions = {
        ["default"] = function(selected)
          local path = selected[1]
          vim.cmd("e " .. path)
          vim.cmd("checktime") -- Verifica se o arquivo foi modificado externamente
        end,
      },
    })
  end,
}
