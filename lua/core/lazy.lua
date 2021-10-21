function lazyload()
  local loader = require"packer".loader
  -- vim.cmd([[syntax on]])
  if vim.wo.diff then
    local plugins = "nvim-treesitter" -- nvim-treesitter-textobjects will be autoloaded with loader
    -- loader(plugins)
    vim.cmd([[packadd nvim-treesitter]])
    require"nvim-treesitter.configs".setup {highlight = {enable = true, use_languagetree = true}}
    -- vim.cmd([[syntax on]])
    return
  end
  local load_lsp = true
  print("I am lazy")

  local disable_ft = {
    "NvimTree", "guihua", "clap_input", "clap_spinner", "TelescopePrompt", "csv", "txt", "defx",
    "sidekick"
  }
  local syn_on = not vim.tbl_contains(disable_ft, vim.bo.filetype)
  if syn_on then
    vim.cmd([[syntax manual]])
  else
    vim.cmd([[syntax on]])
  end

  -- local fname = vim.fn.expand("%:p:f")
  local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f"))
  if fsize == nil or fsize < 0 then
    fsize = 1
  end
  local load_ts_plugins = true
  if fsize > 1024 * 1024 then
    load_ts_plugins = false
    load_lsp = false
  end
  if fsize > 6 * 1024 * 1024 then
    -- vim.cmd([[syntax off]])
    return
  end

  if vim.bo.filetype == 'lua' then
    loader("lua-dev.nvim")
  end

  local plugins = "plenary.nvim" -- nvim-lspconfig navigator.lua   guihua.lua navigator.lua  -- gitsigns.nvim
  loader(plugins)
  vim.g.vimsyn_embed = 'lPr'
  
  loader("indent-blankline.nvim")

  local gitrepo = vim.fn.isdirectory('.git/index')
  if gitrepo then 
    loader("gitsigns.nvim neogit vgit.nvim")  -- vgit.nvim 
  end

  if load_lsp then
    loader("nvim-lspconfig") -- null-ls.nvim
  end

  require("vscripts.cursorhold")
  require("vscripts.tools")

  if load_lsp or load_ts_plugins then
    loader("lsp_signature.nvim")
    loader("guihua.lua")
    loader("navigator.lua")
  end

  local bytes = vim.fn.wordcount()['bytes']
  -- print(bytes)

  if load_ts_plugins then
    plugins = "nvim-treesitter nvim-treesitter-refactor nvim-ts-autotag nvim-ts-context-commentstring" --  nvim-ts-rainbow  nvim-treesitter nvim-treesitter-refactor
    
    -- nvim-treesitter-textobjects should be autoloaded
    loader(plugins)
    -- enable syntax if is small
    -- if fsize < 512 * 1024 and syn_on then
    --   vim.cmd([[setlocal syntax=on]])
    -- end
    -- return -- do not enable syntax
    -- else
    --   vim.cmd([[setlocal syntax=on]])
  end

  if bytes < 2 * 1024 * 1024 and syn_on then
    vim.cmd([[setlocal syntax=on]])
  end

  vim.cmd([[autocmd FileType vista setlocal syntax=on]])
  vim.cmd([[autocmd FileType guihua setlocal syntax=on]])
  vim.cmd(
      [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") end]])
  vim.cmd(
      [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] < 2048000 then print("syntax on") vim.cmd("setlocal syntax=on") end]])

end

vim.cmd([[autocmd User LoadLazyPlugin lua lazyload()]])
vim.cmd("command! Gram lua require'modules.tools.config'.grammcheck()")
vim.cmd("command! Spell call spelunker#check()")

local lazy_timer = 80
vim.defer_fn(function()
  vim.cmd([[doautocmd User LoadLazyPlugin]])
end, lazy_timer)

vim.defer_fn(function()
  -- lazyload()
  vim.cmd([[doautocmd ColorScheme]])
end, lazy_timer + 20)
