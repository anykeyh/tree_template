require "../src/tree_template"

# Fast and Simple Template System
template = TreeTemplate.new do |t|
  t.doctype :html5
  t.html("class": "xxx", h: "yyy", w: 12, data: {on: {click: "dosomething", change: "wtf"}}) do
    t.body do
      10.times do
        t.comment "This is a comment"
        t.div(id: "some-id") do
          t.text "test"
        end
        t.div "test2"
      end
    end
  end
end

puts template.render
