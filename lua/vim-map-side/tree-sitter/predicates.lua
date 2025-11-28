local keymap_fns = { "vim.keymap.set", "vim.api.nvim_set_keymap" }
local modemap_fns = {}

---@type table<string, TSPredicate?>
local predicates = {
  ["is-keymap-fn?"] = function(match, _, bufnr, pred)
    local node = match[pred[2]]
    if node == nil then
      return false
    end

    local fn_text = vim.treesitter.get_node_text(node, bufnr)

    return vim.tbl_contains(keymap_fns, fn_text)
  end,
  ["is-modemap-fn?"] = function(match, _, bufnr, pred)
    local node = match[pred[2]]
    if node == nil then
      return false
    end

    local fn_text = vim.treesitter.get_node_text(node, bufnr)

    return vim.tbl_contains(modemap_fns, fn_text)
  end,
}

---@param opts VimMapSide.TS.Opts
local function setup(opts)
  local predicate_options = require("vim-map-side.compat").predicate_options

  vim.list_extend(keymap_fns, opts.custom_fns.keymap)
  vim.list_extend(modemap_fns, opts.custom_fns.modemap)

  if #modemap_fns == 0 then
    predicates["is-modemap-fn?"] = nil
  else
    require("vim-map-side.tree-sitter.queries").setup()
  end

  for name, handler in pairs(predicates) do
    if handler ~= nil then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.treesitter.query.add_predicate(name, handler, predicate_options)
    end
  end
end

return { setup = setup }
