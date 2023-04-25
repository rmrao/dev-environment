local M = {}

function M.setup(servers, server_options)
  local lspconfig = require "lspconfig"
  local icons = require "config.icons"

  require("mason").setup {
    ui = {
      icons = {
        package_installed = icons.lsp.server_installed,
        package_pending = icons.lsp.server_pending,
        package_uninstalled = icons.lsp.server_uninstalled,
      },
    },
  }
  -- require("mason-null-ls").setup {
  --   automatic_setup = true,
  -- }
  -- require("mason-null-ls").setup_handlers()

  require("mason-tool-installer").setup {
    ensure_installed = { "codelldb", "stylua", "shfmt", "shellcheck", "prettierd" },
    auto_update = false,
    run_on_start = true,
  }

  require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
  }

  -- Package installation folder
  local install_root_dir = vim.fn.stdpath "data" .. "/mason"

  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
      lspconfig[server_name].setup(opts)
    end,
    ["jdtls"] = function()
      -- print "jdtls is handled by nvim-jdtls"
    end,
    ["lua_ls"] = function()
      local opts = vim.tbl_deep_extend("force", server_options, servers["lua_ls"] or {})
      require("neodev").setup {}
      lspconfig.lua_ls.setup(opts)
    end,
  }
end

return M
