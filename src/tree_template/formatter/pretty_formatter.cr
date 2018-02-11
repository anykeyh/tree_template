class TreeTemplate::PrettyFormatter < TreeTemplate::Formatter
  @buffer = IO::Memory.new

  def clear
    @buffer.clear
  end

  def to_s
    @buffer.to_s
  end

  def <<(x)
    concat(x.to_s)
  end

  # def concat(c : Char)
  #   if c == '\n'
  #     front_space = "  " * @level
  #     @buffer << "\n#{front_space}"
  #   else
  #     c
  #   end
  # end

  def nl
    @buffer << "\n"
  end

  def concat(s : String)
    front_space = "  " * @level
    @buffer << (front_space + s.gsub(/\n/, "\n#{front_space}"))
  end
end
