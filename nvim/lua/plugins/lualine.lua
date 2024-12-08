-- lua/plugins/lualine.lua


local function git_repo_name()
  local remote_name = io.popen("git remote show 2>/dev/null"):read("*l")
  if not remote_name or remote_name == "" then return nil end

  local remote_url = io.popen("git remote get-url " .. remote_name .. " 2>/dev/null"):read("*a"):gsub("%s+$", "")
  if not remote_url or remote_url == "" then return nil end

  return remote_url:match("([^/]+)%.git$") or remote_url:match("([^/]+)$")
end


local function git_commit_hash()
  local untracked = 'untracked'
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    return untracked
  end

  local handle = io.popen("git log -n 1 --pretty=format:%h -- " .. file_path .. " 2>/dev/null")
  if not handle then
    return untracked
  end

  local commit_hash = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  return commit_hash ~= "" and commit_hash or untracked
end

local function current_lsp_client()
  local filetype = vim.bo.filetype
  local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  if #client_names > 0 then
    return filetype .. "(" .. table.concat(client_names, ", ") .. ")"
  else
    return filetype
  end
end

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
          lualine_a = { { 'mode', fmt = function(name) return string.lower(name) .. ' mode' end, color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_b = { { 'diff', color = { bg = '#0d1117', fg = '#fff' } }, { 'diagnostics', color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_c = {},
          lualine_x = { { 'encoding', color = { fg = '#aaa', bg = '#0d1117' } } },
          lualine_y = { { 'fileformat', color = { fg = '#aaa', bg = '#0d1117' } } },
          lualine_z = { { function() return current_lsp_client() end, color = { fg = '#aaa', bg = '#0d1117' } } }
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
              branch_name)
            local remote = git_repo_name()
            if remote then
              return remote .. '@' .. branch_name .. ' (' .. git_commit_hash() .. ')'
            else
              return 'no remote'
            end
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
            } } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { { 'location', color = { bg = '#0d1117', fg = '#fff' } } },
          lualine_z = { { 'progress', fmt = string.lower, color = { bg = '#0d1117', fg = '#fff' } } }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  }
}
