return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Remove prettier de arquivos phtml (PHP templates)
    -- O php-cs-fixer cuida da formatação via BufWritePost
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft["phtml"] = {}
    opts.formatters_by_ft["php"] = {}
    return opts
  end,
}
