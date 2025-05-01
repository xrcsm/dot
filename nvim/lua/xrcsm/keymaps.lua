-- lua/xrcsm/keymaps.lua

local M = {}


local nmap = function(keys, func, desc, bufnr)
  local opts = { desc = desc }
  if bufnr then
    opts.buffer = bufnr
  end
  vim.keymap.set('n', keys, func, opts)
end

function insert_include_guard()
  local filename = vim.fn.expand("%:t:r")
  if filename == "" then
    print("No file name detected.")
    return
  end

  local guard = string.upper(filename) .. "_HPP"
  local lines = {
    "#ifndef " .. guard,
    "#define " .. guard,
    "",
    "",
    "#endif // " .. guard
  }

  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.api.nvim_win_set_cursor(0, { 4, 0 })
end

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

  -- Netrw
  nmap('<leader><C-e>', vim.cmd.Ex, '[E]xplore files')

  -- Open terminal
  nmap('<leader><C-t>', vim.cmd.te, '[T]erminal mode')

  -- Telescope search
  local telescope = require('telescope.builtin')
  nmap('<leader>ff', telescope.find_files, '[F]ind [F]iles')
  nmap('<C-f>', telescope.live_grep, '[L]ive [G]rep')
  nmap('<leader>gf', telescope.git_files, 'Search [G]it [F]iles')
  nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Remove highlight
  vim.keymap.set("n", "<leader>h", "<cmd>nohl<cr>")

  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Buffers and windows
  nmap('<leader>b', ':ls<CR>:b<Space>', 'List buffers')

  -- Source Lua script
  nmap('<leader><C-s>', '<Cmd>so<CR><C-l>', 'Source Lua script')

  vim.keymap.set('v', '<leader>q', [[c"<C-r>""<Esc>]], {
    desc = '[Q]uote selected text',
  })
end

M.on_attach = function(bufnr)
  -- LSP key mappings
  local telescope = require('telescope.builtin')

  nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition', bufnr)
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)
  nmap('gr', telescope.lsp_references, '[G]oto [R]eferences', bufnr)
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation', bufnr)
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', bufnr)
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', bufnr)
  nmap('<leader><space>', function()
    require("conform").format({ async = true })
  end, '[F]ormat [F]ile', bufnr)
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition', bufnr)
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', bufnr)
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', bufnr)
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders', bufnr)

  nmap('<leader><space>', vim.lsp.buf.format, 'Format current buffer', bufnr)

  -- Diagnostic keymaps
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
  nmap('<leader>q', telescope.diagnostics, 'Open diagnostics list')

  -- C++ Include Guards
  nmap("<leader>ig", "<cmd>lua insert_include_guard()<CR>", 'Insert include guard')
end

return M
