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

  if compat.has_0_11 then
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

return { setup = setup }
