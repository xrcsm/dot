-- lua/config/keymaps.lua

local M = {}

M.setup = function()
  -- General keymaps
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Save the file
  vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

  -- Move between splits
  vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

  -- Resize splits
  vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

  -- Telescope search
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[L]ive [G]rep' })
  vim.keymap.set('n', '<leader>gf', telescope.git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', '<leader>ws', telescope.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
  vim.keymap.set('n', '<leader>ds', telescope.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })

  -- LSP-related keymaps (Example for diagnostics)
  vim.api.nvim_set_keymap('n', '<leader>ld', ':LspDiagnostics<CR>', { noremap = true, silent = true })

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '<leader><space>', vim.lsp.buf.format, { desc = 'Format current buffer' })

  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Buffers and windows
  vim.keymap.set('n', '<leader>b', ':ls<CR>:b<Space>', { desc = 'List buffers' })
end

return M
