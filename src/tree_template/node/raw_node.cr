class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@raw : String); end

  def render(renderer : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    renderer.concat(@raw)
  end
end
