-- lua/startup.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {}

local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local all_files = vim.fn.readdir(plugins_dir)
local plugin_files = vim.tbl_filter(function(f)
  return f:match("%.lua$")
end, all_files)

for _, file in ipairs(plugin_files) do
  local plugin_name = file:gsub("%.lua$", "")
  local success, plugin_spec_or_err = pcall(require, "plugins." .. plugin_name)

  if not success then
    vim.notify("Error loading plugin " .. plugin_name .. ": " .. plugin_spec_or_err, vim.log.levels.ERROR)
  else
    if type(plugin_spec_or_err) == "table" then
      if #plugin_spec_or_err > 0 then
        for _, spec in ipairs(plugin_spec_or_err) do
          if type(spec) == "table" then
            table.insert(plugin_specs, spec)
          else
            vim.notify("Invalid plugin spec in " .. plugin_name, vim.log.levels.ERROR)
          end
        end
      else
        table.insert(plugin_specs, plugin_spec_or_err)
      end
    else
      vim.notify("Invalid plugin spec: " .. tostring(plugin_spec_or_err), vim.log.levels.ERROR)
    end
  end
end

require('lazy').setup(plugin_specs)

require('config.options').setup()
require('config.keymaps').setup()
require('config.autocmds').setup()
