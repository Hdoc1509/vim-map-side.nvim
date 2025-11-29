---@param opts VimMapSide.TS.Opts
local function setup(opts)
  local ts_parsers = require("nvim-treesitter.parsers")

  local install_info = {
    url = "https://github.com/Hdoc1509/tree-sitter-vim-map-side",
    files = { "src/parser.c" },
    revision = opts.revision,
    requires_generate_from_grammar = opts.from_grammar,
  }
  local parser_info = {
    install_info = install_info,
    -- TODO: add `maintainers` and `tier` fields. check these for `tier`:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4767
    -- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
  }

  if ts_parsers.get_parser_configs ~= nil then
    -- old `main`/`master` branch:
    local parser_configs = ts_parsers.get_parser_configs()
    ---@diagnostic disable-next-line: inject-field
    parser_configs.vim_map_side = parser_info
  elseif ts_parsers.configs ~= nil then
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/692b051b09935653befdb8f7ba8afdb640adf17b
    ts_parsers.configs.vim_map_side = parser_info
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/c17de5689045f75c6244462182ae3b4b62df02d9
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").vim_map_side = parser_info
      end,
    })
  end
end

return { setup = setup }
