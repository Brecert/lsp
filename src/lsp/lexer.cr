require "string_pool"

class Lsp::Lexer
  property token

  def initialize(string)
    @reader = Char::Reader.new(string)
    @token = Token.new
  end

  def serialize_token(char, token = @token)
    case char
    when '\0'
      token.type = :EOF
    when .whitespace?
      token.type = :SPACE
    when '('
      token.type = :"("
    when ')'
      token.type = :")"
    when '$'
      return token.type = :VAR if token.value = consume_name.to_s
      token.type = :"$"
    when .alphanumeric?
      last = current_pos
      if consume_name
        token.value = StringPool.new.get slice_range(last, current_pos + 1)
        return token.type = :NAME
      end
      token.type = :CHAR
    else
      unknown_token
    end
  end

  def next_token
    reset_token

    serialize_token(current_char)
  end

  def next_char_token
    next_char
    next_token
  end

  def consume_name
    if peek_next_char.alphanumeric?
      name = IO::Memory.new
      while peek_next_char.alphanumeric?
        name << next_char
      end
      return name
    end
  end

  def consume_whitespace
    while peek_next_char.whitespace?
      next_char
    end
  end

  def peek_next_token
    serialize_token(peek_next_char, Token.new)
  end

  def next_char
    char = @reader.next_char
    if error = @reader.error
      ::raise InvalidByteSequenceError.new("Unexpected byte 0x#{error.to_s(16)} at position #{@reader.pos}, malformed UTF-8")
    end
    char
  end

  def current_char
    @reader.current_char
  end

  def peek_next_char
    @reader.peek_next_char
  end

  def current_pos
    @reader.pos
  end

  def slice_range(start_pos)
    slice_range(start_pos, current_pos)
  end

  def slice_range(start_pos, end_pos)
    Slice.new(@reader.string.to_unsafe + start_pos, end_pos - start_pos)
  end

  def reset_token
    @token.value = nil
  end

  def unknown_token
    raise "unknown token: #{current_char.inspect} at #{current_pos}"
  end
end
