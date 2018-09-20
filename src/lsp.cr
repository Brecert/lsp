require "./lsp/*"

x = Lsp::Parser.parse "($add 10 20 ($addere duo tribus))"
pp x
