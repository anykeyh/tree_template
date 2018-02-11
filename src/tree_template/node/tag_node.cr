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

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << "<" << @__tag_name << TreeTemplate.render_attributes(@attributes) << ">"
    formatter.nl

    formatter.sub_level do
      @children.each_with_index { |c, idx|
        formatter.nl unless idx == 0
        c.render(formatter, page)
      }
    end

    formatter.nl
    formatter << "</" << @__tag_name << '>'
  end
end
