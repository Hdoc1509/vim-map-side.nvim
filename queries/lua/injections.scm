; extends

; === lhs and rhs ===
(function_call
  name: (_) @_fn
  arguments: [
    (arguments
      .
      (_) ; -- mode --
      .
      (string
        (string_content) @injection.content))
    ; format-ignore
    (arguments
      . (_) ; -- mode --
      . (_) ; -- lhs --
      (string
        (string_content) @injection.content))
  ]
  (#is-keymap-fn? @_fn)
  (#lua-match? @injection.content "<%S+>")
  (#set! injection.language "vim_map_side"))

(function_call
  name: (_) @_fn
  arguments: [
    ; format-ignore
    (arguments
      . (_) ; -- buffer --
      . (_) ; -- mode --
      .
      (string
        (string_content) @injection.content))
    ; format-ignore
    (arguments
      . (_) ; -- buffer --
      . (_) ; -- mode --
      . (_) ; -- lhs --
      (string
        (string_content) @injection.content))
  ]
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  (#lua-match? @injection.content "<%S+>")
  (#set! injection.language "vim_map_side"))

; === `:` rhs without <cr> ===
(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#is-keymap-fn? @_fn)
  (#lua-match? @injection.content "^:")
  (#not-lua-match? @injection.content "<cr>")
  (#set! injection.language "vim"))

(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- buffer --
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  (#lua-match? @injection.content "^:")
  (#not-lua-match? @injection.content "<cr>")
  (#set! injection.language "vim"))

; === expressions as rhs ===
(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#is-keymap-fn? @_fn)
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<%S+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))

(function_call
  name: (_) @_fn
  ; format-ignore
  arguments: (arguments
    . (_) ; -- buffer --
    . (_) ; -- mode --
    . (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#eq? @_fn "vim.api.nvim_buf_set_keymap")
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<%S+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))
