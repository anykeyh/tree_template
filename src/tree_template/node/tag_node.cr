class TreeTemplate::TagNode < TreeTemplate::Node
  @children = [] of TreeTemplate::Node
  @attributes = {} of AllowedKey => AllowedValue

  def initialize(@__tag_name : String, **attributes)
    attributes.each do |k, v|
      case v
      when NamedTuple
        @attributes[k] = make_hash(**v)
      when Array
        @attributes[k] = v
      else
        @attributes[k] = v.to_s
      end
    end
  end

  def add_children(any : Node)
    @children << any
  end

  def render(renderer : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    renderer.concat "<#{@__tag_name}#{TreeTemplate.render_attributes(@attributes)}>"

    renderer.sub_level {
      @children.each { |c| c.render(renderer, page) }
    }

    renderer.concat "</#{@__tag_name}>"
  end
end
