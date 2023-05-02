local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
		profile = {
			enable = true,
			threshold = 0,  -- the amount in ms that a plugins load time must be over for it to be included in the profile
	  },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
			packer_bootstrap = true
      vim.cmd [[packadd packer.nvim]]
    end

		-- Run PackerCompile if there are changes in this file
		local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
    vim.api.nvim_create_autocmd(
      { "BufWritePost" },
      { pattern = vim.fn.expand "$MYVIMRC", command = "source <afile> | PackerCompile", group = packer_grp }
    )
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

		-- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Colorscheme
    use {
      "sainnhe/gruvbox-material",
      config = function()
        vim.cmd "colorscheme gruvbox-material"
      end,
    }

    -- Git
    use {
      "TimUntersberger/neogit",
			cmd = "Neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("config.neogit").setup()
      end,
    }

    -- WhichKey
		use {
			 "folke/which-key.nvim",
			 event = "VimEnter",
			 config = function()
				 require("config.whichkey").setup()
			 end,
		}

		-- IndentLine
		use {
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			config = function()
				require("config.indentblankline").setup()
			end,
		}

		-- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

		-- Better Comment
    use {
      "numToStr/Comment.nvim",
			event = "BufReadPre",
      config = function()
        require("config.Comment").setup()
      end,
    }

		-- Easy motion
    use {
      "ggandor/leap.nvim",
			event = "BufReadPre",
      config = function()
        require("config.leap").setup()
      end,
    }

		-- Markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    }

		use {
			"nvim-lualine/lualine.nvim",
			event = "VimEnter",
			config = function()
			 require("config.lualine").setup()
			end,
			requires = { "nvim-web-devicons" },
		}

		use {
			"SmiteshP/nvim-gps",
			requires = "nvim-treesitter/nvim-treesitter",
			module = "nvim-gps",
			config = function()
				require("nvim-gps").setup()
			end,
		}

		use {
			"nvim-treesitter/nvim-treesitter",
			 run = ":TSUpdate",
			 config = function()
				 require("config.treesitter").setup()
			 end,
		}

		use {
		 "kyazdani42/nvim-tree.lua",
		 requires = {
			 "kyazdani42/nvim-web-devicons",
		 },
		 cmd = { "NvimTreeToggle", "NvimTreeClose" },
			 config = function()
				 require("config.nvimtree").setup()
			 end,
		}
		
		-- Buffer line
		use {
			"akinsho/nvim-bufferline.lua",
			event = "BufReadPre",
			wants = "nvim-web-devicons",
			config = function()
				require("config.bufferline").setup()
			end,
		}

		use { 'junegunn/fzf', run = './install --bin', }

		use {
		 "ibhagwan/fzf-lua",
			requires = { "kyazdani42/nvim-web-devicons" },
		}

		-- Completion
		use {
			"ms-jpq/coq_nvim",
			branch = "coq",
			event = "InsertEnter",
			opt = true,
			run = ":COQdeps",
			config = function()
				require("config.coq").setup()
			end,
			requires = {
				{ "ms-jpq/coq.artifacts", branch = "artifacts" },
				{ "ms-jpq/coq.thirdparty", branch = "3p", module = "coq_3p" },
			},
			disable = false,
		}

		-- LSP
		use {
			"neovim/nvim-lspconfig",
			config = function()
				require("config.lsp").setup()
			end,
			requires = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "jayp0521/mason-null-ls.nvim" },
        "folke/neodev.nvim",
				"RRethy/vim-illuminate",
				"jose-elias-alvarez/null-ls.nvim",
        { "b0o/schemastore.nvim", module = { "schemastore" } },
				{
					"j-hui/fidget.nvim",
					config = function()
						require("fidget").setup {}
					end,
				},
			},
		}

		-- Remote Docker
		use { "jamestthompson3/nvim-remote-containers" }


    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
