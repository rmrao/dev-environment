local M = {}

local servers = {
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
	},
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "on",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
	},
  rust_analyzer = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
          -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = {
          enable = false,
        },
      },
    },
	},
  tsserver = {},
  dockerls = {},
  vimls = {},
  -- yamlls = {
  --   schemastore = {
  --     enable = true,
  --   },
  --   settings = {
  --     yaml = {
  --       hover = true,
  --       completion = true,
  --       validate = true,
  --       schemas = require("schemastore").json.schemas(),
  --     },
  --   },
  -- },

}

function M.on_attach(client, bufnr)
  local caps = client.server_capabilities
  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  if caps.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  if caps.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
  end

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  -- Configure formatting
  require("config.lsp.null-ls.formatters").setup(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

M.capabilities = capabilities


local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

-- Setup LSP handlers
-- require("config.lsp.handlers").setup()

function M.setup()
	-- null-ls
	require("config.lsp.null-ls").setup(opts)

  require("config.lsp.installer").setup(servers, opts)
end

return M
