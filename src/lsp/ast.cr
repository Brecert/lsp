module Lsp::AST
  abstract class ASTNode
    def nop?
      self.is_a?(Nop)
    end
  end

  class Nop < ASTNode
  end

  class Expressions < ASTNode
    property expressions : Array(ASTNode)
    property name : ASTNode

    # def self.from(obj : Nil, name : ASTNode)
    #   Nop.new
    # end

    def self.from(obj : Array, name : ASTNode)
      case obj.size
      when 0
        Nop.new
      else
        new obj, name
      end
    end

    def self.from(obj : ASTNode, name : ASTNode)
      new [obj], name
    end

    def initialize(@expressions = [] of ASTNode, @name : ASTNode = Nop.new)
    end
  end

  class Block < ASTNode
    property name : ASTNode
    property value : ASTNode

    def initialize(@value, @name)
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
