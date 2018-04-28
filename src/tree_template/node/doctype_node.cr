require "./node"

class TreeTemplate::DoctypeNode < TreeTemplate::Node
  DOCTYPE = {
    html5:              "html",
    html4_strict:       %(HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"),
    html4_transitional: %(HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"),
    html4_frameset:     %(HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"),
    xhtml_strict:       %(html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"),
    xhtml_transitional: %(html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"),
    xhtml_frameset:     %(html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"),
  }

  def initialize(@text : String); end

  def initialize(from : Symbol)
    @text = DOCTYPE.fetch(from) { raise "Doctype not found: `#{from}`" }
  end

  def render(formatter : TreeTemplate::Formatter, page : TreeTemplate? = nil)
    formatter << "<!DOCTYPE " << @text << '>'
  end
end
