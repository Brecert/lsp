module Lsp::AST
  abstract class ASTNode
    def nop?
      self.is_a?(Nop)
    end
  end

  class Nop < ASTNode
  end

  class Block < ASTNode
    property name : ASTNode
    property expressions : Array(ASTNode)

    def initialize(@expressions : Array(ASTNode), @name)
    end
  end

  class Name < ASTNode
    property name : String

    def initialize(@name)
    end
  end

  class Var < Name
  end

  class Arg < ASTNode
    property value : Array(ASTNode)

    def initialize(@value = [] of ASTNode)
    end
  end
end
