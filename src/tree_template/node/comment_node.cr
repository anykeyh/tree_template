class TreeTemplate::CommentNode < TreeTemplate::Node
  def initialize(@text : String); end

  def render(renderer : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    renderer.concat("<!-- #{@text} -->")
  end
end
