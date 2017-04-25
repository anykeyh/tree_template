class TreeTemplate::TextNode < TreeTemplate::Node
  def initialize(@text : String); end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << TreeTemplate.html_escape(@text)
  end
end
