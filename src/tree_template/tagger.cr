class TreeTemplate::Tagger
  @context = [] of TreeTemplate::TagNode

  INLINE_TAGS = %w(area base br col command embed hr img input keygen link
    meta param source track wbr)

  def [](s : String) : String
    TreeTemplate.html_escape(s)
  end

  def inline_tag(name, **opts)
    inline_tag = TreeTemplate::InlineTagNode.new(name, **opts)
    @context.last.add_children inline_tag
    return inline_tag
  end

  def tag(name : String, content : String = "", **opts)
    context_tag = TreeTemplate::TagNode.new(name, **opts)
    context_tag.add_children(TreeTemplate::TextNode.new(content))
    @context.last.add_children context_tag

    return context_tag
  end

  def tag(name : String, **opts, &proc : Tagger -> Void)
    context_tag = TreeTemplate::TagNode.new(name, **opts)

    @context.last.add_children context_tag if @context.size > 0

    @context.push(context_tag)
    proc.call(self)
    @context.pop

    return context_tag
  end

  def text(content : String)
    text_node = TreeTemplate::TextNode.new(content)
    @context.last.add_children(text_node)
    return text_node
  end

  def comment(content : String)
    comment_node = TreeTemplate::CommentNode.new(content)
    @context.last.add_children(comment_node)
    return comment_node
  end

  macro method_missing(call)
      {% if call.block %}
        def {{call.name}}(**params, &block : Tagger -> Void) : Node
          name = "{{call.name.id}}"

          if INLINE_TAGS.includes?(name)
            raise ArgumentError.new("You're trying to put a block on a auto-closing markup")
          else
            tag(name, **params, &block)
          end
        end
      {% else %}
        def {{call.name}}(content : String = "", **params) : Node
          name = "{{call.name.id}}"

          if INLINE_TAGS.includes?(name)
            inline_tag(name, **params)
          else
            tag(name, content, **params)
          end
        end
      {% end %}
    end
end
