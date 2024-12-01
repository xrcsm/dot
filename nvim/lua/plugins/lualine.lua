-- lua/plugins/lualine.lua

local function get_tmux_session_name()
  local handle = io.popen("tmux display-message -p '#S' 2>/dev/null")
  if not handle then
    return "no session"
  end
  local session_name = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return session_name ~= "" and "tmux(" .. session_name .. ")" or "no session"
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'lualine'.setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = '',
          section_separators = '',
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          }
        },
        sections = {
          lualine_a = { { 'mode', fmt = function(s)
            return s:sub(1, 1)
          end, color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_b = { { 'diff', color = { bg = '#0d1117' } }, { 'diagnostics', color = { bg = '#0d1117' } } },
          lualine_c = {},
          lualine_x = { { 'encoding', color = { fg = '#aaa', bg = '#0d1117' } } },
          lualine_y = { { 'fileformat', color = { fg = '#aaa', bg = '#0d1117' } } },
          lualine_z = { { 'filetype', color = { fg = '#aaa', bg = '#0d1117' } } }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 3 } },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = { { function() return get_tmux_session_name() end, color = { bg = '#0d1117', fg = '#fff' } }, { 'FugitiveHead', fmt = function(
              str)
            return str == '' and 'no branch' or 'at ' .. str
          end, color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_b = { { 'tabs',
            tab_max_length = 40,
            max_length = vim.o.columns / 3,
            mode = 2,
            path = 1,

            tabs_color = {
              active = 'lualine_b_buffers_active',
              inactive = 'lualine_b_buffers_inactive',
            },

            show_modified_status = true,
            symbols = {
              modified = '[+]',
            },

            fmt = function(name, context)
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, '&mod')

              return name .. (mod == 1 and ' +' or '')
            end } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { { 'location', color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_z = { { 'progress', fmt = string.lower, color = { bg = '#0d1117', fg = '#fff' } } }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }

      vim.cmd('highlight lualine_a_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_b_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_c_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_x_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_y_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_z_inactive guibg=#0d1117')
      vim.cmd('highlight lualine_b_buffers_active guifg=#bbbbbb guibg=#0d1117')
      vim.cmd('highlight lualine_b_buffers_inactive guifg=#999999 guibg=#0d1117')

    end
  }
}
