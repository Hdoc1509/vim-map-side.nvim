local M = {}

---@class VimMapSideOpts
---@field from_grammar? boolean -- whether to install from `grammar.js`
---@field revision? string -- specific version of `tree-sitter-vim-map-side`

---@type VimMapSideOpts
local default_opts = {
  from_grammar = false,
  revision = "release",
}

---@param opts? VimMapSideOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

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
end

return M
