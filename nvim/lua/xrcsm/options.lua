-- lua/config/options.lua

local M = {}

M.setup = function()
  local set = vim.opt

  -- Line numbers
  set.number = true
  set.relativenumber = true

  -- Set cursor line
  vim.o.cursorline = true

  -- Tabs and Indentation
  set.tabstop = 2
  set.softtabstop = 2
  set.shiftwidth = 2
  set.expandtab = true
  set.smartindent = true
  set.breakindent = true

  -- Search
  set.ignorecase = true
  set.smartcase = true
  set.hlsearch = false

  -- Completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- Wrapping
  set.wrap = false

  -- Cursor and Scrolling
  set.scrolloff = 8
  set.sidescrolloff = 8

  -- Mouse and Clipboard
  set.mouse = 'a'
  set.clipboard = 'unnamedplus,unnamed'

  -- UI Enhancements
  set.termguicolors = true
  set.signcolumn = 'yes'
  set.cursorline = true

  -- Split Behavior
  set.splitbelow = true
  set.splitright = true

  -- Timeouts
  set.timeoutlen = 300

  -- Backup and Undo
  set.backup = false
  set.writebackup = false
  set.swapfile = false
  set.undofile = true

  -- Performance
  set.updatetime = 300
  set.lazyredraw = true

  -- netrw settings
  vim.g.netrw_banner = 0
  vim.g.netrw_liststyle = 1
  vim.g.netrw_sizestyle = "h"
end

return M
