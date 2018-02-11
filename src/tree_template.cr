require "html"

module OfAncestor(T)
  def self.new(subclass : X, *params, **tuple) forall X
    {% if X <= T.class %}
      subclass.new(*params, **tuple)
    {% else %}
      {% raise "#{X} should inherit from #{T.class}" %}
    {% end %}
  end
end

class TreeTemplate
  alias StringOrSymbol = String | Symbol
  alias AllowedKey = StringOrSymbol
  alias AllowedValue = Bool |
                       Int64 |
                       Int32 |
                       Float64 |
                       String |
                       Array(String) |
                       Array(Symbol) |
                       Array(StringOrSymbol) |
                       Hash(AllowedKey, AllowedValue)

  property formatter : Formatter
  getter template_block : Tagger -> Void

  @tagger : Tagger?
  @is_built = false

  def is_built?
    @is_built
  end

  def initialize(formatter : X = CompactFormatter, &template_block : Tagger -> Void) forall X
    @formatter = OfAncestor(Formatter).new(formatter)
    @template_block = template_block
  end

  def has_content_for?(scope : Symbol)
    @tagger.not_nil!.root_nodes[scope]?
  end

  # :nodoc:
  def draw(scope : Symbol = :_default, page : TreeTemplate? = nil)
    tagger = @tagger

    raise "Draw should be called during render process" if tagger.nil?

    @formatter.clear

    if tagger.root_nodes[scope]?
      tagger.root_nodes[scope].each(&.render(@formatter, page: page))
    end

    @formatter.to_s
  end

  def build
    unless is_built?
      tagger = Tagger.new
      @tagger = tagger
      @template_block.call(tagger)
      @is_built = true
    end
  end

  def render : String
    build
    draw
  end

  def render_as_layout(page : TreeTemplate) : String
    build
    page.build
    draw(page: page)
  end

  @[AlwaysInline]
  def self.html_escape(x : String) : String
    HTML.escape(x)
  end

  def self.render_attributes(attributes : Hash, prefix : String? = nil) : String
    if attributes.size == 0
      ""
    else
      (prefix ? "" : " ") + attributes.map do |(key, value)|
        key_str = key.to_s
        full_key = prefix ? html_escape(prefix + key_str) : html_escape(key_str)

        case value
        when Bool
          full_key
        when Array
          escaped_value = '"' + html_escape(value.map { |x| x.to_s }.join(" ")) + '"'
          [full_key, escaped_value].join("=")
        when Hash
          render_attributes(value, "#{key}-")
        else
          escaped_value = '"' + html_escape(value.to_s) + '"'
          [full_key, escaped_value].join("=")
        end
      end.join(" ")
    end
  end
end

require "./tree_template/components"
require "./tree_template/tagger"

require "./tree_template/formatter"
require "./tree_template/formatter/*"

require "./tree_template/node"
require "./tree_template/node/*"
