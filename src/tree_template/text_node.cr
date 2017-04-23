class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@text : String); end

  def render(renderer : TreeTemplate::Renderer)
    renderer.concat(@text)
  end
end
