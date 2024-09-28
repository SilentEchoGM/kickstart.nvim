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

      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = '[A]dd to Harpoon' })

      vim.keymap.set('n', '<leader>hr', function()
        harpoon:list():remove()
      end, { desc = '[R]emove from Harpoon' })

      vim.keymap.set('n', '<leader><lt>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Toggle Harpoon' })

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
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {}

      vim.keymap.set('n', '<leader>ld', '<cmd>Lspsaga hover_doc<CR>', { desc = '[D]isplay docs' })
      vim.keymap.set({ 'n', 'i' }, '<C-g>', '<cmd>Lspsaga hover_doc<CR>')
      vim.keymap.set('n', '<leader>lp', '<cmd>Lspsaga hover_doc ++keep<CR>', { desc = '[P]in docs' })
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
}
