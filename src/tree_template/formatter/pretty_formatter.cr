class TreeTemplate::PrettyFormatter < TreeTemplate::Formatter
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

  def concat(s : String)
    @buffer << ("  " * @level)
    @buffer << (("  " * @level) + s.gsub(/^[ \t]+/, ""))
    @buffer << "\n"
  end
end
