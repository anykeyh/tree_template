require "benchmark"
require "ecr"
require "../src/tree_template"

item = [{name: "red", current: true, url: "#red"},
        {name: "green", current: false, url: "#green"},
        {name: "blue", current: false, url: "#blue"}]

header = "colors"

template_code : TreeTemplate::Tagger -> Void = ->(t : TreeTemplate::Tagger) {
  t.doctype "html5"
  t.html do
    t.head do
      t.title "Simple Benchmark"
    end
    t.body do
      t.h1 header
      unless item.empty?
        t.ul do
          item.each do |i|
            t.li { i[:current] ? t.strong i[:name] : t.a i[:name], href: i[:url] }
          end
        end
      else
        t.p "The list is empty."
      end
    end
  end
  nil
}

class TemplateECR
  def item
    @item
  end

  def header
    @header
  end

  def initialize(@header : String, @item : Array(NamedTuple(name: String, current: Bool, url: String))); end

  ECR.def_to_s "example/benchmark.ecr"
end

Benchmark.ips do |x|
  x.report("render template (html-template)") do
    TreeTemplate.new(&template_code).render
  end

  x.report("render template (ecr)") do
    TemplateECR.new(header, item).to_s
  end
end
