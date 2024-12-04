-- lua/plugins/init.lua

return {
  {
    'hrsh7th/nvim-cmp', -- Neovim completion
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-a>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
        },
      }
    end
  },
  {
    'neovim/nvim-lspconfig',                              -- Core LSP support
    dependencies = {
      'williamboman/mason.nvim',                          -- Manage LSP servers
      'williamboman/mason-lspconfig.nvim',                -- Bridge mason and lspconfig
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} }, -- LSP notifications UI
      {
        'ray-x/lsp_signature.nvim',                       -- Provide signature help
        event = "VeryLazy"
      }
    },
    config = function()
      require('mason').setup()

      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'clangd', 'pyright', 'ts_ls', 'svelte', 'rust_analyzer' },
      }

      local lsp_signature_opts = {
        hint_prefix = {
          above = "↙ ", -- when the hint is on the line above the current line
          current = "← ", -- when the hint is on the same line
          below = "↖ " -- when the hint is on the line below the current line
        },
        hint_inline = function() return true end,
        
        bind = true,
        handler_opts = {
          border = "rounded"
        },
      }
      require('lsp_signature').setup(lsp_signature_opts)

      local keymaps = require 'xrcsm.keymaps'

      local on_attach = function(client, bufnr)
        keymaps.on_attach(bufnr)

        if client.name == "svelte" then
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end

        vim.lsp.inlay_hint.enable()
      end

      local lspconfig = require('lspconfig')

      -- Lua (lua_ls)
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- C/C++ (clangd)
      lspconfig.clangd.setup {
        on_attach = on_attach,
        cmd = { "/usr/bin/clangd", "--header-insertion=never", "--clang-tidy", "--background-index" },
      }

      -- Python (pyright)
      lspconfig.pyright.setup {
        on_attach = on_attach,
      }

      -- Rust (rust-analyzer)
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = { allFeatures = true },
            procMacro = { enable = true },
          },
        },

      }

      -- JS/TS (ts_ls)
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
      }

      -- Svelte (svelte-language-server)
      lspconfig.svelte.setup {
        on_attach = on_attach,
      }
    end,
  },
}
