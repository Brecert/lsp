require "./syntax/ast"

module Lsp
  class Runner
    getter ast

    def initialize(@ast : ASTNode)
      @variables = {} of String => ASTNode
      walk(@ast)
    end

    def walk(node : ASTNode)
      raise "unknown node #{node}"
    end

    def walk(node : Block)
      node.expressions.each do |exp|
        if exp.is_a? Arg
          execute node
        end
        walk exp
      end
    end

    def walk(node : Arg)
      node.values.each do |exp|
        walk exp
      end
    end

    def walk(node : Var)
      node
    end

    def walk(node : Name)
      node
    end

    def execute(node : Block)
      exp = node.expressions[0].as(Arg)
      case node.name.as(Var).name
      when "add"
        val1 = exp.values[0].as(Name)
        val2 = exp.values[1].as(Name)
        val1.name.to_i + val2.name.to_i
      when "print"
        exp.values.each do |e|
          puts(execute e)
        end
      end
    end

    def execute(node : ASTNode)
      node.to_s
    end

    def execute(node : Name)
      node.name
    end
  end
end
