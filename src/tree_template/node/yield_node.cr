class TreeTemplate::YieldNode < TreeTemplate::Node
  def initialize(@for : Symbol); end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    if page
      formatter << page.draw(@for)
    end
  end
end
