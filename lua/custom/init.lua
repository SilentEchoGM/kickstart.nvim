local root_names = { '.git', '.jj' }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return
  end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  vim.fn.chdir(root)
end

local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })

local e_sveltekit_file = function(type)
  vim.ui.input({
    prompt = 'filename:',
  }, function(input)
    if input == '' then
      return
    end
    if input == nil then
      return
    end
    local cmd = 'e src/' .. type .. '/' .. input
    vim.cmd(cmd)
  end)
end

vim.keymap.set({ 'n' }, '<leader>pr', function()
  e_sveltekit_file 'routes'
end, { desc = 'Create SvelteKit [P]roject [R]oute file' })
vim.keymap.set({ 'n' }, '<leader>pl', function()
  e_sveltekit_file 'lib'
end, { desc = 'Create SvelteKit [P]roject [L]ib file' })

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
