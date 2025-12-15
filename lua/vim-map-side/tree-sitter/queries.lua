local function setup()
  local compat = require("vim-map-side.compat")

  local injection_query = ""

  if compat.has_0_11 then
    -- see new features in treesiter section
    -- https://neovim.io/doc/user/news-0.11.html#_new-features
    -- https://neovim.io/doc/user/treesitter.html#vim.treesitter.query.set()
    -- NOTE: follow updates of https://github.com/neovim/neovim/issues/36959
    -- injection_query = "; inherits: lua,vms_modemap_fn"
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

  local modemap_query_path =
    vim.treesitter.query.get_files("vms_modemap_fn", "injections")[1]
  local modemap_query_file = assert(io.open(modemap_query_path, "r"))

  local modemap_query = modemap_query_file:read("*a") --[[@as string]]

  modemap_query_file:close()
  injection_query = injection_query .. modemap_query

  pcall(vim.treesitter.query.set, "lua", "injections", injection_query)
end

return { setup = setup }
