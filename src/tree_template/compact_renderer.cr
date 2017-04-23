class TreeTemplate::CompactRenderer < TreeTemplate::Renderer
  @buffer = String::Builder.new

  def clear
    @buffer = String::Builder.new
  end

  def to_s
    @buffer.to_s
  end

  def concat(s : String)
    @buffer << s
  end
end
