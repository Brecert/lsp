require "./lsp/*"

module Lsp
  nodes = Parser.parse "($print test ($add 39 333) 10)"
  pp nodes
  Runner.new(nodes)
end
