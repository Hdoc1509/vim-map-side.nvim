; extends

(map_statement
  rhs: (map_side) @injection.content
  (#lua-match? @injection.content "^:")
  (#set! injection.include-children)
  (#set! injection.language "vim_map_side"))
