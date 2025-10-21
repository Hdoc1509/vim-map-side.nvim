; extends

; NOTE: for lhs
(function_call
  name: (dot_index_expression) @_fn
  arguments: (arguments
    .
    (_) ; -- mode --
    .
    (string
      (string_content) @injection.content))
  (#eq? @_fn "vim.keymap.set")
  (#lua-match? @injection.content "<.+>")
  (#set! injection.language "vim_map_side"))

; NOTE: for general rhs
(function_call
  name: (dot_index_expression) @_fn
  arguments: (arguments
    .
    (_) ; -- mode --
    .
    (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#eq? @_fn "vim.keymap.set")
  (#lua-match? @injection.content "<.+>")
  (#set! injection.language "vim_map_side"))

; NOTE: for `:` rhs without keycode
(function_call
  name: (dot_index_expression) @_fn
  arguments: (arguments
    .
    (_) ; -- mode --
    .
    (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content))
  (#eq? @_fn "vim.keymap.set")
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @injection.content "^:")
  (#set! injection.language "vim_map_side"))

; NOTE: for expressions as rhs
(function_call
  name: (dot_index_expression) @_fn
  arguments: (arguments
    .
    (_) ; -- mode --
    .
    (_) ; -- lhs --
    .
    (string
      (string_content) @injection.content)
    .
    (table_constructor) @_options)
  (#eq? @_fn "vim.keymap.set")
  ; NOTE: to avoid double injection
  (#not-lua-match? @injection.content "<.+>")
  (#lua-match? @_options "expr%s*=%s*true")
  (#set! injection.language "vim_map_side"))
