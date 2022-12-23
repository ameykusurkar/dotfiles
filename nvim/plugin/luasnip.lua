local ls = require('luasnip')

ls.add_snippets("lua", {
  ls.parser.parse_snippet("fu", "function $1($2)\n  $0\nend", {}),
})

ls.add_snippets("ruby", {
  ls.parser.parse_snippet("if", "if $1\n  $0\nend", {}),
  ls.parser.parse_snippet("def", "def $1\n  $0\nend", {}),
  ls.parser.parse_snippet("defs", "def self.$1\n  $0\nend", {}),

  ls.parser.parse_snippet("map", "map { |$1| $0 }", {}),
  ls.parser.parse_snippet("mapd", "map do |$1|\n  $0\nend", {}),

  ls.parser.parse_snippet("let", "let(:$1) { $0 }", {}),
  ls.parser.parse_snippet("let!", "let!(:$1) { $0 }", {}),
  ls.parser.parse_snippet("letd", "let(:$1) do \n  $0\nend", {}),
  ls.parser.parse_snippet("let!d", "let!(:$1) do \n  $0\nend", {}),
})
