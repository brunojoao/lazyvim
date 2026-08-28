-- Claude Code rodando DENTRO do Neovim (split via snacks.nvim).
--
-- Histórico: isto já esteve em `provider = "external"` (janela do Terminator)
-- porque a TUI do Claude redesenha a tela sem parar (spinner + streaming) e o
-- :terminal do Neovim às vezes parava de pintar — a tela congelava enquanto o
-- servidor e o Claude seguiam vivos.
--
-- Voltamos para dentro do editor. O que muda em relação à primeira tentativa:
--   * `scrollback` do buffer do terminal derrubado de 10000 para 2000 linhas
--     (ver autocmd abaixo) — é o maior custo por frame;
--   * enfeite de janela desligado no split do Claude, que também é redesenhado
--     a cada frame;
--   * o caminho do binário é expandido aqui, sem depender de shell.
-- Se o congelamento voltar, `<leader>ax` devolve a janela externa na hora, sem
-- precisar editar config nem reiniciar o Neovim.

local CLAUDE_BIN = vim.fn.expand("~/.local/bin/claude")

-- Fallback: abre o Claude numa janela do Terminator.
--   Retornar tabela => o plugin usa como argv direto, sem shell-split.
--   -u  : desativa o DBus. Sem isso o Terminator reaproveita a instância já
--         aberta e a nova aba herdaria o ambiente DELA, perdendo
--         CLAUDE_CODE_SSE_PORT / ENABLE_IDE_INTEGRATION.
--   -x  : usa o resto dos argumentos como o comando a executar.
--   sh -c: expande os args (--resume, --continue).
local function terminator_cmd(cmd, _env)
  return {
    "terminator",
    "-u",
    "--working-directory=" .. vim.fn.getcwd(),
    "-x",
    "sh",
    "-c",
    cmd,
  }
end

-- Troca o provider em tempo de execução. `terminal.setup()` sobrescreve
-- terminal_cmd/env com o 2º e 3º argumentos, então repassamos os valores que já
-- estão no state do plugin — passar nil aqui apagaria os dois.
local function swap_provider()
  local ok, cc = pcall(require, "claudecode")
  local term_ok, term = pcall(require, "claudecode.terminal")
  if not (ok and term_ok) then
    return
  end

  pcall(term.close)

  local current = vim.g.claude_provider or "snacks"
  local next_provider = current == "snacks" and "external" or "snacks"

  term.setup({ provider = next_provider }, cc.state.config.terminal_cmd, cc.state.config.env)
  vim.g.claude_provider = next_provider

  vim.notify(
    "Claude: " .. (next_provider == "snacks" and "split do Neovim" or "janela do Terminator"),
    vim.log.levels.INFO
  )
end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal_cmd = CLAUDE_BIN,
    terminal = {
      provider = "snacks",
      split_side = "right",
      split_width_percentage = 0.35,
      snacks_win_opts = {
        wo = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          statuscolumn = "",
          list = false,
          spell = false,
          wrap = false,
        },
      },
      provider_opts = {
        external_terminal_cmd = terminator_cmd,
      },
    },
  },
  config = function(_, opts)
    require("claudecode").setup(opts)
    vim.g.claude_provider = "snacks"

    -- A TUI reescreve a tela inteira a cada frame e tudo que sai do topo cai no
    -- scrollback. Com o padrão de 10000 linhas o Neovim passa mais tempo
    -- remanejando esse buffer do que desenhando — é o principal suspeito do
    -- congelamento. 2000 linhas ainda dá histórico de sobra para rolar.
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("claude_term_tuning", { clear = true }),
      callback = function(ev)
        if not vim.api.nvim_buf_get_name(ev.buf):match("claude") then
          return
        end
        vim.bo[ev.buf].scrollback = 2000
      end,
    })

    vim.api.nvim_create_user_command("ClaudeCodeSwapProvider", swap_provider, {
      desc = "Alterna o Claude entre split do Neovim e janela do Terminator",
    })
  end,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>ax", "<cmd>ClaudeCodeSwapProvider<cr>", desc = "Claude: split <-> janela externa" },
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
