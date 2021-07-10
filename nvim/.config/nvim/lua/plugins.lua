-- packer boilerplate and other good ideas shamelessly stolen from LunarVim:
-- https://github.com/ChristianChiarulli/LunarVim
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  vim.api.nvim_command("packadd packer.nvim")
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

packer.init {
  git = { clone_timeout = 300 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile"

return require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Language Server Protocol configuration
  use {
    "neovim/nvim-lspconfig",
    config = function() require('config.lspconfig') end,
  }

  -- A Swiss Army Knife for finding things; a modern ctrlp.vim
  use {
    "nvim-telescope/telescope.nvim",
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function()
      require("telescope").setup {
        pickers = {
          tags = {
            ctags_file = ".tags",
          }
        }
      }
      vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>pb', ':Telescope buffers<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>pt', ':Telescope tags<CR>', {noremap = true})
    end,
  }

  -- Legacy linting, mainly for shellcheck. Planning to lean more heavily on LSP.
  use {
    'dense-analysis/ale',
    ft = {'sh', 'bash', 'zsh', 'markdown'},
    config = function() vim.g.ale_python_mypy_options = '--ignore-missing-imports' end
  }

  -- Auto-completion
  use {
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function() require('config.compe') end,
  }

  -- Treesitter support for neovim
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = {"go", "python", "toml", "fish"},
        highlight = { enable = true },
      }
    end,
  }

  -- Treesitter highlighting tangles with Vim's spell checking; this fixes it.
  use {
    'lewis6991/spellsitter.nvim',
    config = function() require('spellsitter').setup() end,
  }

  -- Automatically generate and update a ctags file for the current project
  use {
    'ludovicchabant/vim-gutentags',
    config = function() vim.g.gutentags_ctags_tagfile = '.tags' end,
  }

  use {
    'chriskempson/base16-vim',
    config = function() vim.cmd('colorscheme base16-phd') end,
  }

  -- Swap between single- and multi-line formats for lists, function arguments, etc.
  use {
    'FooSoft/vim-argwrap',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>a', ':ArgWrap<CR>', {noremap = true})
    end,
  }

  -- vimgrep but fast (because of ripgrep)
  use {
    'mileszs/ack.vim',
    config = function()
      vim.g.ackprg = 'rg --vimgrep --smart-case'
      vim.api.nvim_set_keymap('n', '<leader>*', ':AckFromSearch!<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<leader>/', ':Ack!<Space>', {noremap = true})
    end
  }

  -- Don't repeat yourself; use Vim to the fullest!
  use {
    'takac/vim-hardtime',
    config = function()
      vim.cmd 'autocmd VimEnter * silent! call HardTimeOn()'
      vim.g.hardtime_allow_different_key = 1
      vim.g.hardtime_ignore_quickfix = 1
      vim.g.hardtime_maxcount = 7
    end,
  }

  -- The notorious Git plugin
  use 'tpope/vim-fugitive'

  -- Commands for adding, modifying, and deleting pairs of quotes, brackets, etc.
  use 'tpope/vim-surround'

  -- Show diff when editing commit message
  use 'rhysd/committia.vim'

  -- Git change status in the left gutter
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end,
  }

  -- Explore Vim's history of a file and revert to old versions
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  }

end)
