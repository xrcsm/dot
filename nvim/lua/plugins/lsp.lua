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
        ensure_installed = { 'lua_ls', 'clangd', 'pyright', 'ts_ls' },
      }

      local lsp_signature_opts = {
        hint_prefix = {
          above = "↙ ", -- when the hint is on the line above the current line
          current = "← ", -- when the hint is on the same line
          below = "↖ " -- when the hint is on the line below the current line
        },
        bind = true,
        handler_opts = {
          border = "rounded"
        },
      }
      require('lsp_signature').setup(lsp_signature_opts)

      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        vim.lsp.inlay_hint.enable()

        -- LSP key mappings
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('<leader><space>', function() vim.lsp.buf.format { async = true } end, '[F]ormat [F]ile')
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>ww', vim.diagnostic.get, '')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
      end

      local lspconfig = require('lspconfig')

      -- Lua Language Server
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- Clangd (C/C++)
      lspconfig.clangd.setup {
        on_attach = on_attach,
        cmd = { "/usr/bin/clangd", "--header-insertion=never", "--clang-tidy", "--background-index" },
      }

      -- Python (Pyright)
      lspconfig.pyright.setup {
        on_attach = on_attach,
      }

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

      -- JavaScript/TypeScript (ts_ls)
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
      }
    end,
  },
}
