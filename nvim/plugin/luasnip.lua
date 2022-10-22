local ls = require('luasnip')

ls.add_snippets("lua", {
  ls.parser.parse_snippet("fu", "function $1($2)\n  $0\nend", {}),
})
