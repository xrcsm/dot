-- lua/xrcsm/autocmds.lua

local M = {}

M.setup = function()
  -- Highlight on yank
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  -- vim.api.nvim_create_autocmd("VimEnter", {
  --   callback = function()
  --     os.execute("tmux set status off")
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd("VimLeave", {
  --   callback = function()
  --     os.execute("tmux set status on")
  --   end,
  -- })
end

return M
