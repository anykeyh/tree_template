class TreeTemplate::PrettyFormatter < TreeTemplate::Formatter
  @buffer = IO::Memory.new(8096)

  def clear
    @buffer.clear
  end

  def to_s
    @buffer.to_s
  end

  def concat(s : String)
    @buffer << ("  " * @level)
    @buffer << (("  " * @level) + s.gsub(/^[ \t]+/, ""))
    @buffer << "\n"
  end
end
