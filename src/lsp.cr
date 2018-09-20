require "./lsp/*"

module Lsp
  class TranslateToJs < Transformer
    def transform(node : Var)
      Name.new("#{node.name} =")
    end
  end

  nodes = Parser.parse "($add 10 20 ($addere duo tribus))"
  pp nodes.transform(TranslateToJs.new)
end
