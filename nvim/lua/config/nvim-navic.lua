local M = {}

function M.setup()
  require("nvim-navic").setup {
    lsp = {
      auto_attach = true,
    }
  }
end

return M
