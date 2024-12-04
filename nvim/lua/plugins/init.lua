-- lua/plugins/init.lua

return {
  { 'folke/which-key.nvim', opts = {} },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
}
