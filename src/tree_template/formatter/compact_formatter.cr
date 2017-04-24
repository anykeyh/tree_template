class TreeTemplate::CompactFormatter < TreeTemplate::Formatter
  class_property initial_buffer_size = 8096

  @buffer = IO::Memory.new(TreeTemplate::CompactFormatter.initial_buffer_size)

  def clear
    @buffer.clear
  end

  def to_s
    @buffer.to_s
  end

  def concat(s : String)
    @buffer << s
  end
end
