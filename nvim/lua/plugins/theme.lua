-- ~/.config/nvim/lua/plugins/theme.lua

return {
  {
    'projekt0n/github-nvim-theme',
    lazy = false,    -- Load during startup
    priority = 1000, -- Load before all other plugins
    config = function()
      require('github-theme').setup({
        groups = {
          all = {
            CursorLine = { bg = '#434343' },
            Visual = { bg = '#4343EE', fg = '#FFFFFF' },
          },
        },
      })
      vim.cmd('colorscheme github_dark_default')
    end,
  }
}
