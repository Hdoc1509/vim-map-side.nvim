local M = {}

---@class VimMapSide.TS.Opts.CustomFns
---@field keymap? string[] custom functions with same parameters of `vim.keymap.set()`
---@field modemap? string[] same functions as `keymap` option but without first parameter (`mode`)

---@class VimMapSide.TS.Opts
---@field from_grammar? boolean whether to install from `grammar.js`
---@field revision? string specific version of `tree-sitter-vim-map-side`
---@field custom_fns? VimMapSide.TS.Opts.CustomFns

---@type VimMapSide.TS.Opts
local default_opts = {
  from_grammar = false,
  revision = nil,
  custom_fns = { keymap = {}, modemap = {} },
}

---@param opts? VimMapSide.TS.Opts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  require("vim-map-side.tree-sitter.parser-config").setup(opts)
  require('vim-map-side.tree-sitter.predicates').setup(opts)
end

return M
