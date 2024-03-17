local M = {}

function M.setup()
  local whichkey = require "which-key"

  local conf = {
    window = {
      border = "single",   -- none, single, double, shadow
      position = "bottom", -- bottom, top
    },
  }
  whichkey.setup(conf)

  local opts = {
    mode = "i",     -- Insert mode
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }


  local mappings = {
    ["<C-space>"] = { "<C-x><C-o>" },
    ["<C-@>"] = { "<C-x><C-o>" },
  }

  whichkey.register(mappings, opts)

  opts = {
    mode = "n",     -- Normal mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  mappings = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close current buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
      n = { ":BufferLineCycleNext<CR>", "Go to next buffer" },
      p = { ":BufferLineCyclePrev<CR>", "Go to prev buffer" },
    },

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    t = {
      name = "Git",
      s = { "<cmd>Neogit<CR>", "Status" },
    },

    f = {
      name = "Find",
      f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Files" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
      g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live grep" },
      h = { "<cmd> lua require('telescope.builtin').help_tags()<cr>", "Help Tags" },
      e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    },
  }

  whichkey.register(mappings, opts)

  opts = {
    mode = "n",     -- Normal mode
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  mappings = {
    t = {
      name = "Nvim Tree",
      o = { ":NvimTreeToggle<cr>", "Open Nvim Tree" },
      e = { ":NvimTreeToggle %:h<cr>", "Open Nvim Tree" },
    }
  }

  whichkey.register(mappings, opts)

end

return M
