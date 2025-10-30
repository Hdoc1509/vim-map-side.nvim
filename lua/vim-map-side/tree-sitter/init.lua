local M = {}

---@class VimMapSide.TSOpts.CustomFns
---@field keymap? string[] custom functions with same parameters of `vim.keymap.set()`
---@field modemap? string[] same functions as `keymap` option but without first parameter (`mode`)

---@class VimMapSide.TSOpts
---@field from_grammar? boolean whether to install from `grammar.js`
---@field revision? string specific version of `tree-sitter-vim-map-side`
---@field custom_fns? VimMapSide.TSOpts.CustomFns

---@type VimMapSide.TSOpts
local default_opts = {
  from_grammar = false,
  revision = nil,
  custom_fns = { keymap = {}, modemap = {} },
}

---@param opts? VimMapSide.TSOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  require("vim-map-side.tree-sitter.parser-config").setup(opts)
  require("vim-map-side.tree-sitter.predicates.keymap-fn").setup(opts)
  require("vim-map-side.tree-sitter.predicates.modemap-fn").setup(opts)
end

return M
