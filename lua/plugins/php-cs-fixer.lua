return {
  "stephpy/vim-php-cs-fixer",
  lazy = false,
  config = function()
    -- Mapeia o comando para corrigir o diretório inteiro
    vim.api.nvim_set_keymap("n", "<leader>cp", "", { desc = "PhpCsFixer" })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cpd",
      ":call PhpCsFixerFixDirectory()<CR>",
      { desc = "PhpCsFixerFixDirectory", noremap = true, silent = true }
    )

    -- Mapeia o comando para corrigir o arquivo atual
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cpf",
      ":call PhpCsFixerFixFile()<CR>",
      { desc = "PhpCsFixerFixFile", noremap = true, silent = true }
    )

    -- Configurações do php-cs-fixer
    -- Se php-cs-fixer estiver no $PATH, você não precisa definir a linha abaixo
    -- vim.g.php_cs_fixer_path = "~/php-cs-fixer.phar"  -- define o caminho para o php-cs-fixer.phar

    -- Se você usar a versão 1.x do php-cs-fixer
    vim.g.php_cs_fixer_level = "symfony" -- opções: --level (default:symfony)
    vim.g.php_cs_fixer_config = "default" -- opções: --config
    -- Se você quiser definir fixadores específicos:
    -- vim.g.php_cs_fixer_fixers_list = "linefeed,short_tag" -- opções: --fixers
    -- vim.g.php_cs_fixer_config_file = '.php_cs'      -- opções: --config-file
    -- Fim dos parâmetros de configuração da versão 1 do php-cs-fixer

    -- Se você usar a versão 2.x do php-cs-fixer
    -- vim.g.php_cs_fixer_rules = "@PSR2"              -- opções: --rules (default:@PSR2)
    -- vim.g.php_cs_fixer_cache = ".php_cs.cache"      -- opções: --cache-file
    vim.g.php_cs_fixer_config_file = ".php-cs-fixer.php" -- usa o config do projeto
    vim.g.php_cs_fixer_allow_risky = "yes" -- opções: --allow-risky
    -- Fim dos parâmetros de configuração da versão 2 do php-cs-fixer

    vim.g.php_cs_fixer_php_path = "php" -- Caminho para o PHP
    vim.g.php_cs_fixer_enable_default_mapping = 0 -- Ativa o mapeamento por padrão (<leader>pcd)
    vim.g.php_cs_fixer_dry_run = 0 -- Chama o comando com a opção dry-run
    vim.g.php_cs_fixer_verbose = 0 -- Retorna a saída do comando se 1, caso contrário, uma informação inline.
    -- vim.g.php_cs_fixer_ignore_env = 1                 -- Ignorar quaisquer requisitos de ambiente
    --
    --
    -- Autocomando para php-cs-fixer desativado
    -- (usar manualmente com <leader>cpf para não conflitar com config do projeto)
    -- vim.api.nvim_create_autocmd("BufWritePost", {
    --   pattern = {"*.php", "*.phtml"},
    --   callback = function()
    --     vim.cmd("silent! call PhpCsFixerFixFile()")
    --   end,
    -- })
  end,
}
