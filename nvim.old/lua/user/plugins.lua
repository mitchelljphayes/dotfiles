local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packaddpacker.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
    use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    use "numToStr/Comment.nvim" -- Easily comment stuff
    use 'kyazdani42/nvim-web-devicons'
    use {'kyazdani42/nvim-tree.lua', tag = 'nightly', requires = {'kyazdani42/nvim-web-devicons'}}
    use {"akinsho/bufferline.nvim", tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
    use {"akinsho/toggleterm.nvim", tag = "*"}
    use "moll/vim-bbye"
    use 'nvim-lualine/lualine.nvim'
    use "ahmedkhalf/project.nvim"
    use 'lewis6991/impatient.nvim'
    use "lukas-reineke/indent-blankline.nvim"
    use 'goolord/alpha-nvim'
    use "antoinemadec/FixCursorHold.nvim"
    use "folke/which-key.nvim"

    -- markdown
    use "junegunn/goyo.vim"
    use "junegunn/limelight.vim"

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-media-files.nvim"

    -- Colorschemes
    use "lunarvim/colorschemes"
    use "sainnhe/everforest"
    use "Shatur/neovim-ayu"
    use {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}

    -- Note Taking
    use "mickael-menu/zk-nvim"

    -- cmp plugins
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig" -- enable LSP
    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

    use "ray-x/lsp_signature.nvim"
    use "SmiteshP/nvim-navic"
    use "simrat39/symbols-outline.nvim"
    use "b0o/SchemaStore.nvim"
    use 'simrat39/rust-tools.nvim'
    use "RRethy/vim-illuminate"
    use "j-hui/fidget.nvim"
    use "simrat39/inlay-hints.nvim"
    use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"

    -- copilot config
    use "github/copilot.vim"
    use {
      "zbirenbaum/copilot-cmp",
      -- after = { "lua.user.copilot" },
      -- config = function ()
      --   require("copilot_cmp").setup()
      -- end
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow"
    use "nvim-treesitter/playground"
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- Git
    use "lewis6991/gitsigns.nvim"
    use "f-person/git-blame.nvim"
    use "ruifm/gitlinker.nvim"

    -- DAP
    use "mfussenegger/nvim-dap"
    use "theHamsta/nvim-dap-virtual-text"
    use "rcarriga/nvim-dap-ui"
    use "Pocco81/DAPInstall.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
