require "../src/tree_template"

# Fast and Simple Template System
layout = TreeTemplate.new do |t|
  t.doctype :html5
  t.html do
    t.head do
      t.meta(content: "test", value: "12")
      t.yield(:head)
    end

    t.yield
  end
end

page = TreeTemplate.new do |t|
  t.content_for(:head) do
    t.div "Content for head"
  end

  t.div "Use yield on layout to apply this content !"
end

puts layout.render(page)
