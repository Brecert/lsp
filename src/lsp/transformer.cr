require "./syntax/ast"
require "./transformer/*"

class Lsp::Transformer
  def transform(node : Block)
    exps = [] of ASTNod
    node.expressions.each do |exp|
      new_exp = exp.transform(self)
      if new_exp
        if new_exp.is_a?(Block)
          exps.concat new_exp.expressions
        else
          exps << new_exp
        end
      end
    end
  end
end
