class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@raw : String); end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << @raw
  end
end
