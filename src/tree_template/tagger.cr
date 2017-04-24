class TreeTemplate::Tagger
  @context = [] of TreeTemplate::TagNode
  getter root_nodes = {} of Symbol => Array(TreeTemplate::Node)

  @content_target = :_default

  def initialize; end

  def [](string : String) : String
    TreeTemplate.html_escape(string)
  end

  def <<(node : Node)
    if @context.size > 0
      @context.last.add_children(node)
    else
      root_nodes[@content_target] ||= [] of TreeTemplate::Node
      root_nodes[@content_target] << node
    end
  end

  def inline_tag(name, **opts)
    inline_tag = TreeTemplate::InlineTagNode.new(name, **opts)
    self << inline_tag
  end

  def tag(name : String, __content : String = "", **opts)
    context_tag = TreeTemplate::TagNode.new(name, **opts)
    context_tag.add_children(TreeTemplate::TextNode.new(__content))

    self << context_tag
  end

  def tag(name : String, **opts, &proc : Tagger -> Void)
    context_tag = TreeTemplate::TagNode.new(name, **opts)

    self << context_tag

    @context.push(context_tag)
    proc.call(self)
    @context.pop
  end

  def yield(scope : Symbol = :_default)
    self << TreeTemplate::YieldNode.new(scope)
  end

  def text(__content : String)
    self << TreeTemplate::TextNode.new(__content)
  end

  def raw(__content : String)
    self << TreeTemplate::RawNode.new(__content)
  end

  def content_for(scope : Symbol, &proc : Tagger -> Void)
    raise "You cannot put a content_for... in a content_for !" if @content_target != :_default
    old, @content_target = @content_target, scope
    proc.call(self)
    @content_target = old
  end

  def doctype(__content : String | Symbol)
    self << TreeTemplate::DoctypeNode.new(__content)
  end

  def comment(__content : String)
    self << TreeTemplate::CommentNode.new(__content)
  end

  macro method_missing(call)
    {% inline_tags = %w(area base br col command embed hr img input keygen link
         meta param source track wbr) %}
      {% if call.block %}
        def {{call.name}}(**params, &block : Tagger -> Void)
          {% if inline_tags.includes?(call.name) %}
            {% raise ArgumentError.new("You're trying to put a block on a auto-closing markup `#{call.name}`") %}
          {% else %}
            tag("{{call.name.id}}", **params, &block)
          {% end %}
        end
      {% else %}
        def {{call.name}}(__content : String = "", **params)
          {% if inline_tags.includes?(call.name) %}
            inline_tag("{{call.name.id}}", **params)
          {% else %}
            tag("{{call.name.id}}", __content, **params)
          {% end %}
        end
      {% end %}
    end
end
