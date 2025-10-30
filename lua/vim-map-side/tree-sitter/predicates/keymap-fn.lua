local keymap_fns = { "vim.keymap.set", "vim.api.nvim_set_keymap" }

---@param opts VimMapSide.TSOpts
local function setup(opts)
  local compat = require("vim-map-side.compat")

  vim.list_extend(keymap_fns, opts.custom_fns.keymap)

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
    compat.predicate_options
  )
end

return { setup = setup }
