---@param opts VimMapSide.TS.Opts
local function setup(opts)
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

return { setup = setup }
