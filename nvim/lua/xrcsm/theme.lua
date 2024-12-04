-- lua/xrcsm/theme.lua

local M = {}

M.load = function()
  local sections = { 'a', 'b', 'c', 'x', 'y', 'z' }
  for _, section in ipairs(sections) do
    vim.cmd(string.format('highlight lualine_%s_active guibg=#0d1117', section))
    vim.cmd(string.format('highlight lualine_%s_inactive guibg=#0d1117', section))
  end

  local buffer_highlights = {
    { 'lualine_b_buffers_active',   '#bbbbbb' },
    { 'lualine_b_buffers_inactive', '#999999' },
  }
  for _, highlight in ipairs(buffer_highlights) do
    vim.cmd(string.format('highlight %s guifg=%s guibg=#0d1117', highlight[1], highlight[2]))
  end

  vim.cmd('highlight LspSignatureActiveParameter guifg=#f85149 guibg=#2c171b')
end

return M
