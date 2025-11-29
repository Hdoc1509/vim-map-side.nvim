local M = {}

M.has_0_10 = vim.fn.has("nvim-0.10") == 1
M.has_0_11 = vim.fn.has("nvim-0.11") == 1

---@param capture_index number
---@param match table<integer, TSNode | TSNode[]>
---@param pred any[]
M.get_node = function(capture_index, match, pred)
  local node = match[pred[capture_index]]

  if M.has_0_10 then
    ---@cast node TSNode[]
    if not node then
      return nil
    else
      return node[1]
    end
  end

  return node --[[@as TSNode?]]
end

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
M.predicate_options = M.has_0_10 and { all = true } or nil

return M
