require "./syntax"

module Lsp
  class ASTNode
    def transform(transformer)
      node = transformer.transform self
    end
  end

  class Transformer
    def transform(node : Block)
      exps = [] of ASTNode
      node.expressions.each do |exp|
        new_exp = exp.transform(self)
        if new_exp
          if new_exp.is_a?(Block)
            exps.concat new_exp.expressions
          else
            exps << new_exp
          end
        end

        if exps.size == 1
          exps[0]
        else
          node.expressions = exps
          node
        end
      end
    end

    def transform(node : Nop)
      node
    end

    def transform(node : Arg)
      node.values.each { |exp| exp.transform(self) }
    end

    def transform(node : Name)
      node
    end

    def transform(node : Var)
      node
    end
  end
end
