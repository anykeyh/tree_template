class TreeTemplate::InlineTagNode < TreeTemplate::Node
  @attributes = {} of AllowedKey => AllowedValue

  def initialize(@__tag_name : String, **attributes)
    @attributes = make_hash(**attributes)
  end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << '<' << @__tag_name << TreeTemplate.render_attributes(@attributes) << " >"
  end
end
