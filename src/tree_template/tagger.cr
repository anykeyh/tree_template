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

  def inline_tag(__tag_name : String, **opts)
    inline_tag = TreeTemplate::InlineTagNode.new(__tag_name, **opts)
    self << inline_tag
  end

  def tag(__tag_name : String, __content : String = "", **opts)
    context_tag = TreeTemplate::TagNode.new(__tag_name, **opts)
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

  # Generate the methods for each tags
  {% for t in %w(a abbr address area article aside audio b base bdi bdo blockquote body br button canvas caption cite code col colgroup data datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins kbd keygen label legend li link main map mark math menu menuitem meta meter nav noscript object ol optgroup option output p param picture pre progress q rb rp rt rtc ruby s samp script section select slot small source span strong style sub summary sup svg table tbody td template textarea tfoot th thead time title tr track u ul var video wbr) %}
    {%
      inline_tags = %w(area base br col command embed hr img input keygen link meta param source track wbr)
    %}

    {% if inline_tags.includes?(t) %}
      def {{t.id}}(**params)
        inline_tag({{t}}, **params)
      end
    {% else %}
      def {{t.id}}(__content : String = "", **params)
        tag({{t}}, __content, **params)
      end

      def {{t.id}}(**params, &block : Tagger -> Void)
        tag({{t}}, **params, &block)
      end
    {% end %}
  {% end %}

  # Include the custom components
  include TreeTemplate::Components
end
