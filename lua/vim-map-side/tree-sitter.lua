local M = {}

-- TODO: split into:
-- init.lua
-- register.lua
-- predicates/
--   keymap-fn.lua
--   modemap-fn.lua

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_0_10 = vim.fn.has("nvim-0.10") == 1
local predicate_options = has_0_10 and {} or nil

local has_0_11 = vim.fn.has("nvim-0.11") == 1

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
local keymap_fns = { "vim.keymap.set", "vim.api.nvim_set_keymap" }
local modemap_fns = {}

---@param opts? VimMapSide.TSOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  vim.list_extend(keymap_fns, opts.custom_fns.keymap)
  vim.list_extend(modemap_fns, opts.custom_fns.modemap)

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

  if #modemap_fns == 0 then
    return
  end

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

  local injection_query = ""
  local modemap_query = [[; query
  ; === lhs and rhs
  (function_call
    name: (_) @_fn
    arguments: [
      (arguments
        .
        (string
          (string_content) @injection.content))
      (arguments
        . (_) ; -- lhs --
        .
        (string
          (string_content) @injection.content))
    ]
    (#is-modemap-fn? @_fn)
    (#lua-match? @injection.content "<%S+>")
    (#set! injection.language "vim_map_side"))

  ; === `:` rhs without <cr> ===
  (function_call
    name: (_) @_fn
    arguments: (arguments
      . (_) ; -- lhs --
      .
      (string
        (string_content) @injection.content))
    (#is-modemap-fn? @_fn)
    (#lua-match? @injection.content "^:")
    (#not-lua-match? @injection.content "<cr>")
    (#set! injection.language "vim"))

  ; === expressions as rhs ===
  (function_call
    name: (_) @_fn
    arguments: (arguments
      . (_) ; -- lhs --
      .
      (string
        (string_content) @injection.content)
      .
      (table_constructor) @_options)
    (#is-modemap-fn? @_fn)
    ; NOTE: to avoid double injection
    (#not-lua-match? @injection.content "<%S+>")
    (#lua-match? @_options "expr%s*=%s*true")
    (#set! injection.language "vim_map_side"))
  ]]

  if has_0_11 then
    -- see new features in treesiter section
    -- https://neovim.io/doc/user/news-0.11.html#_new-features
    -- https://neovim.io/doc/user/treesitter.html#vim.treesitter.query.set()
    injection_query = "; extends\n"
  else
    -- reference:
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/10126effbafb74541b69219711dfb2c631e7ebf8/lua/render-markdown/core/ts.lua#L56-L69
    local files = vim.treesitter.query.get_files("lua", "injections")

    for _, file in ipairs(files) do
      local f = assert(io.open(file, "r"))
      local body = f:read("*a") --[[@as string]]

      f:close()
      injection_query = injection_query .. body .. "\n"
    end
  end

  injection_query = injection_query .. modemap_query

  pcall(vim.treesitter.query.set, "lua", "injections", injection_query)
end

return M
