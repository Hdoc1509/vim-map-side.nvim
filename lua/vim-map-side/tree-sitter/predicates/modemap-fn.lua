local modemap_fns = {}

---@param opts VimMapSide.TSOpts
local function setup(opts)
  local compat = require("vim-map-side.compat")

  vim.list_extend(modemap_fns, opts.custom_fns.modemap)

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
    compat.predicate_options
  )

  local injection_query = ""

  if compat.has_0_11 then
    -- see new features in treesiter section
    -- https://neovim.io/doc/user/news-0.11.html#_new-features
    -- https://neovim.io/doc/user/treesitter.html#vim.treesitter.query.set()
    injection_query = "; inherits: modemap_fn\n"
  else
    -- reference:
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/10126effbafb74541b69219711dfb2c631e7ebf8/lua/render-markdown/core/ts.lua#L56-L69
    local files = vim.treesitter.query.get_files("lua", "injections")
    local modemap_query_path =
      vim.treesitter.query.get_files("vms_modemap_fn", "injections")

    for _, file in ipairs(files) do
      local f = assert(io.open(file, "r"))
      local body = f:read("*a") --[[@as string]]

      f:close()
      injection_query = injection_query .. body .. "\n"
    end

    local modemap_query_file = assert(io.open(modemap_query_path[1], "r"))
    local modemap_query = modemap_query_file:read("*a") --[[@as string]]

    modemap_query_file:close()

    injection_query = injection_query .. modemap_query
  end

  pcall(vim.treesitter.query.set, "lua", "injections", injection_query)
end

return { setup = setup }
