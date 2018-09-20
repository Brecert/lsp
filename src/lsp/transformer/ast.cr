class Lsp::ASTNode
  def transform(transformer)
    node = transformer.transform self
  end
end
