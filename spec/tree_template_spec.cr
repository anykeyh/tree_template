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
