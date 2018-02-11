require "./spec_helper"

describe TreeTemplate, "#render" do
  it "should print the text" do
    template = TreeTemplate.new formatter: TreeTemplate::CompactFormatter do |t|
      t.html { t.text "Hello" }
    end

    template.render.should eq("<html>Hello</html>")
  end
end

describe TreeTemplate, "#render_inline" do
  it "should render the input markup as auto-close markup" do
    template = TreeTemplate.new formatter: TreeTemplate::CompactFormatter do |t|
      t.html { t.input(type: "text") }
    end

    # puts template.render
    template.render.should eq("<html><input type=\"text\" ></html>")
  end
end

describe TreeTemplate, "#render_classes_as_array" do
  it "should perfectly render an array of class" do
    template = TreeTemplate.new formatter: TreeTemplate::CompactFormatter do |t|
      t.html { t.div("class": ["a", "b", "c"]) }
    end

    template.render.should eq("<html><div class=\"a b c\"></div></html>")
  end
end

describe TreeTemplate, "pretty formatter" do
  template = TreeTemplate.new formatter: TreeTemplate::PrettyFormatter do |t|
    t.html do
      t.div do
        t.text("This is a text\nWith space into it.")
      end
      t.div "Another text here?"
    end
  end

  template.render.should eq <<-HTML
  <html>
    <div>
      This is a text
      With space into it.
    </div>
    <div>
      Another text here?
    </div>
  </html>
  HTML
end

module TreeTemplate::Components
  def my_component(x : Int32)
    div { text "This would be great #{x}!" }
  end
end

describe TreeTemplate, "usage of components" do
  template = TreeTemplate.new do |t|
    t.my_component(5)
  end

  template.render.should eq("<div>This would be great 5!</div>")
end

describe TreeTemplate, "usage with kilt" do
  it "Should be used with kilt" do
  end
end
