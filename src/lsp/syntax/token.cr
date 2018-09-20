class Lsp::Token
  property type : Symbol
  property value : Char | String | Symbol | Nil

  def initialize
    @type = :EOF
  end

  def to_s
    "#{@type}"
  end
end
