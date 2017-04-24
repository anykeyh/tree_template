class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@text : String); end

  def render(renderer : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    renderer.concat(TreeTemplate.html_escape(@text))
  end
end
