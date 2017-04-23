require "html"

class TreeTemplate
  alias StringOrSymbol = String | Symbol
  alias AllowedKey = StringOrSymbol
  alias AllowedValue = Bool |
                       Int64 |
                       Float64 |
                       String |
                       Array(String) |
                       Array(Symbol) |
                       Array(StringOrSymbol) |
                       Hash(AllowedKey, AllowedValue)

  DIRECTIVES = {
    html5:              "<!DOCTYPE html>",
    html4_strict:       %(<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">),
    html4_transitional: %(<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">),
    html4_frameset:     %(<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">),
    xhtml_strict:       %(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">),
    xhtml_transitional: %(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">),
    xhtml_frameset:     %(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">),
  }

  @tagger = Tagger.new
  property renderer : Renderer
  class_property default_renderer : Renderer = PrettyRenderer.new

  def initialize(@root = "html", @directive : Symbol | String = "", @renderer : Renderer = TreeTemplate.default_renderer, &block : Tagger -> Void)
    @block = block
  end

  def render : String
    directive = @directive

    @renderer.clear

    root_node = @tagger.tag(@root, &@block)

    if directive.is_a?(Symbol)
      directive = DIRECTIVES.fetch(directive) {
        raise ArgumentError.new("Directive not known : #{directive}")
      }
    elsif directive.is_a?(String)
      directive
    end

    root_node.render(@renderer)
    directive + @renderer.to_s
  end

  @[AlwaysInline]
  def self.html_escape(x : String) : String
    HTML.escape(x)
  end

  def self.render_attributes(attributes : Hash, prefix = "") : String
    if attributes.size == 0
      ""
    else
      (prefix.blank? ? " " : "") + attributes.map do |(key, value)|
        key_str = key.to_s

        full_key = html_escape(prefix + key_str)

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

require "./tree_template/tagger"

require "./tree_template/renderer"
require "./tree_template/compact_renderer"
require "./tree_template/pretty_renderer"

require "./tree_template/node"
require "./tree_template/comment_node"
require "./tree_template/inline_tag_node"
require "./tree_template/tag_node"
require "./tree_template/text_node"
