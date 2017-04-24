class TreeTemplate::InlineTagNode < TreeTemplate::Node
  @attributes = {} of AllowedKey => AllowedValue

  def initialize(@__tag_name : String, **attributes)
    @attributes = make_hash(**attributes)
  end

  def render(renderer : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    renderer.concat("<#{@__tag_name}#{TreeTemplate.render_attributes(@attributes)} >")
  end
end
