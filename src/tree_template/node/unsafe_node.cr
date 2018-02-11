class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@text : String); end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << @text
  end
end
