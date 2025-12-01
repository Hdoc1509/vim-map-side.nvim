local M = {}

---@class VimMapSide.TS.Opts.CustomFns
---Custom functions with same parameters of `vim.keymap.set()`.
---@field keymap? string[]
---Same functions as `keymap` option but without first parameter (`mode`).
---@field modemap? string[]

---@class VimMapSide.TS.Opts
---Whether to `generate` files from the grammar before building it.
---@field from_grammar? boolean
---Path to local `tree-sitter-vim-map-side`. If set, `url`, `revision` and `branch` options are ignored.
---@field path? string
---Remote URL to `tree-sitter-vim-map-side`.
---@field url? string
---Version or commit of `tree-sitter-vim-map-side`. If set, `branch` option is ignored.
---@field revision? string specific version of `tree-sitter-vim-map-side`
---Branch of `tree-sitter-vim-map-side`
---@field branch? string
---@field custom_fns? VimMapSide.TS.Opts.CustomFns

---@type VimMapSide.TS.Opts
local default_opts = {
  url = "https://github.com/Hdoc1509/tree-sitter-vim-map-side",
  -- TODO: remove `branch` option. Use `revision` as `branch` too.
  branch = "master",
  custom_fns = { keymap = {}, modemap = {} },
}

---@param opts? VimMapSide.TS.Opts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  require("vim-map-side.tree-sitter.parser-info").setup(opts)
  require("vim-map-side.tree-sitter.predicates").setup(opts)
end

return M
