-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'julienvincent/hunk.nvim',
    cmd = { 'DiffEditor' },
    config = function()
      require('hunk').setup()
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'yaocccc/nvim-foldsign',
    config = function()
      require('nvim-foldsign').setup()
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>')
    end,
    ft = { 'markdown' },
  },
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
  {
    'zschreur/telescope-jj.nvim',
    config = function()
      local builtin = require 'telescope.builtin'
      local telescope = require 'telescope'
      telescope.load_extension 'jj'

      local vcs_picker = function(opts)
        local jj_pick_status, _jj_res = pcall(telescope.extensions.jj.files, opts)
        if jj_pick_status then
          return
        end

        vim.print 'falling back to git'

        local git_files_status, _git_res = pcall(builtin.git_files, opts)
        if git_files_status then
          return
        end

        vim.print 'falling back to all files'
        pcall(builtin.find_files, opts)
      end

      vim.keymap.set('n', '<leader>sf', vcs_picker, { desc = '[S]earch JJ [F]iles' })
    end,
  },
  {
    'jvgrootveld/telescope-zoxide',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'zoxide'
      vim.keymap.set('n', '<leader>sz', require('telescope').extensions.zoxide.list, { desc = '[S]earch [Z]oxide' })
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup()

      vim.keymap.set('n', '<leader>ba', function()
        harpoon:list():add()
      end, { desc = '[A]dd to Harpoon' })

      vim.keymap.set('n', '<leader>b_', function()
        harpoon:list():remove()
      end, { desc = 'Remove from Harpoon' })

      vim.keymap.set('n', '<leader><leader>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Toggle Harpoon' })

      vim.keymap.set('n', '<leader>br', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon 1' })

      vim.keymap.set('n', '<leader>be', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon 2' })

      vim.keymap.set('n', '<leader>b<Space>', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon 3' })

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}

        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>sh', function()
        toggle_telescope(harpoon:list())
      end, {
        desc = '[S]earch [H]arpoon',
      })
    end,
  },
  {
    'willothy/nvim-cokeline',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for v0.4.0+
      'nvim-tree/nvim-web-devicons', -- If you want devicons
    },
    config = function()
      require('cokeline').setup {
        show_if_buffers_are_at_least = 2,
      }

      local mappings = require 'cokeline.mappings'

      require('which-key').add {
        { '<leader>b', group = '[B]uffers' },
      }
      vim.keymap.set('n', '<leader>b;', function()
        mappings.by_step('focus', 1)
      end, { desc = 'Next Buffer' })

      vim.keymap.set('n', '<leader>b,', function()
        mappings.by_step('focus', -1)
      end, { desc = 'Prev Buffer' })
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        lightbulb = {
          virtual_text = false,
        },
      }

      vim.keymap.set('n', '<leader>ld', '<cmd>Lspsaga hover_doc<CR>', { desc = '[D]isplay docs' })
      vim.keymap.set({ 'n', 'i' }, '<C-g>', '<cmd>Lspsaga hover_doc<CR>')
      vim.keymap.set('n', '<leader>lp', '<cmd>Lspsaga hover_doc ++keep<CR>', { desc = '[P]in docs' })
      vim.keymap.set({ 'n', 'i' }, '<C-m>', '<cmd>Lspsaga hover_doc ++keep<CR>')
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {
        settings = {
          tsserver_file_preferences = {
            noErrorTruncation = true,
          },
        },
      }

      vim.keymap.set({ 'n', 'i' }, '<C-e>', '<cmd>TSToolsAddMissingImports<CR>')
      vim.keymap.set({ 'n', 'i' }, '<C-E>', '<cmd>TSToolsRemoveUnusedImports<CR>')
      vim.keymap.set('n', '<leader>li', '<cmd>TSToolsAddMissingImports<CR>', { desc = 'Add Missing [I]mports' })
      vim.keymap.set('n', '<leader>lu', '<cmd>TSToolsRemoveUnusedImports<CR>', { desc = 'Remove [U]nused Imports' })
    end,
  },
  {
    'rktjmp/lush.nvim',
  },
  {
    'willothy/flatten.nvim',
    config = true,
    lazy = false,
    priority = 1001,
  },
  {
    'stevearc/oil.nvim',
    --@module 'oil'
    --@type oill.SetupOpts
    opts = {},
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.keymap.set({ 'n', 'i' }, '<leader>e', '<cmd>Oil<CR>', {
        desc = 'Open Oil',
      })

      require('oil').setup {
        default_file_explorer = true,
        columns = { 'icon', 'mtime' },
        delete_to_trash = true,
      }
    end,
  },
}
