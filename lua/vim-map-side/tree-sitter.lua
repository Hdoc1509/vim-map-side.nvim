local M = {}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local predicate_options = has_v_0_10 and {} or nil

---@class VimMapSideOpts.CustomFns
---@field keymap? string[] custom functions with same parameters of `vim.keymap.set()`

---@class VimMapSideOpts
---@field from_grammar? boolean whether to install from `grammar.js`
---@field revision? string specific version of `tree-sitter-vim-map-side`
---@field custom_fns? VimMapSideOpts.CustomFns

---@type VimMapSideOpts
local default_opts = {
  from_grammar = false,
  revision = nil,
  custom_fns = { keymap = {} },
}
local keymap_fns = { "vim.keymap.set", "vim.api.nvim_set_keymap" }
local modemap_fns = {}

---@param opts? VimMapSideOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  vim.list_extend(keymap_fns, opts.custom_fns.keymap)

  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  ---@diagnostic disable-next-line: inject-field
  parser_configs.vim_map_side = {
    install_info = {
      url = "https://github.com/Hdoc1509/tree-sitter-vim-map-side",
      files = { "src/parser.c" },
      revision = opts.revision,
      requires_generate_from_grammar = opts.from_grammar,
    },
    filetype = "vms",
  }

  vim.treesitter.query.add_predicate(
    "is-keymap-fn?",
    function(match, _, bufnr, pred)
      local node = match[pred[2]]
      if node == nil then
        return false
      end

      local fn_text = vim.treesitter.get_node_text(node, bufnr)

      return vim.tbl_contains(keymap_fns, fn_text)
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    predicate_options
  )

  vim.treesitter.query.add_predicate(
    "is-modemap-fn?",
    function(match, _, bufnr, pred)
      local node = match[pred[2]]
      if node == nil then
        return
      end

      local fn_text = vim.treesitter.get_node_text(node, bufnr)

      return vim.tbl_contains(modemap_fns, fn_text)
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    predicate_options
  )
end

return M
