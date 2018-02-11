class TreeTemplate::CompactFormatter < TreeTemplate::Formatter
  # class_property initial_buffer_size = 32

  @buffer = IO::Memory.new

  def clear
    @buffer.clear
  end

  def to_s
    @buffer.to_s
  end

  def <<(x)
    @buffer << x
  end

  def nl
  end

  def concat(s : String)
    @buffer << s
  end
end
