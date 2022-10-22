local ls = require('luasnip')

ls.add_snippets("lua", {
  ls.parser.parse_snippet("foo", "bar"),
})
