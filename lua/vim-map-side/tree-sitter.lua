local M = {}

---@class VimMapSideOpts
---@field from_grammar? boolean

---@param opts? VimMapSideOpts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", { from_grammar = false }, opts or {})

  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  ---@diagnostic disable-next-line: inject-field
  parser_configs.vim_map_side = {
    install_info = {
      url = "https://github.com/Hdoc1509/tree-sitter-vim-map-side",
      files = { "src/parser.c" },
      branch = "release",
      requires_generate_from_grammar = opts.from_grammar,
    },
  }
end

return M
