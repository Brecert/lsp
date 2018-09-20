class Lsp::Parser < Lsp::Lexer
  include AST

  def self.parse(string)
    new(string).parse
  end

  def initialize(string)
    super(string)
  end

  def parse
    parse_expression
  end

  def parse_expression
    next_token
    expect :"("

    name = parse_var
    args = parse_args

    expect :")"

    Block.new args, name
  end

  def parse_args(exps = [] of ASTNode)
    consume_whitespace
    next_char_token
    types = [:NAME, :VAR, :"("]
    accept types do
      case @token.type
      when :NAME
        exps << Name.new(@token.value.to_s)
      when :VAR
        exps << parse_var
      when :"("
        exps << parse_expression
      else
        exps << parse_args
      end
      parse_args(exps)
    end

    Arg.new exps
  end

  def parse_var
    consume_whitespace
    next_char_token

    expect :VAR
    Var.new(@token.value.to_s)
  end

  def accept?(token_type)
    token_type == @token.type
  end

  def accept(token_types : Array)
    token_types.each do |token_type|
      if accept? token_type
        yield token_type
        break
      end
    end
  end

  def expect(token_types : Array)
    raise "expecting any of these tokens: #{token_types.join ", "} (not '#{@token.type.to_s}')" unless token_types.any? { |type| @token.type == type }
  end

  def expect(token_type)
    raise "expecting token '#{token_type}' not '#{@token.to_s}'" unless token_type == @token.type
  end

  def raise(message, location = current_pos)
    ::raise "#{message} at #{current_pos}"
  end
end
