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

describe TreeTemplate, "Usage of layout" do
  it "Should be able to yield in layout" do
    layout = TreeTemplate.new formatter: TreeTemplate::PrettyFormatter do |t|
      t.html do
        t.head do
          t.title "A cool page!"
          t.yield(:seo)
        end
        t.body do
          t.div(class: "content") do
            t.yield
          end
        end
      end
    end

    page = TreeTemplate.new formatter: TreeTemplate::PrettyFormatter do |t|
      t.div "This is the content of a page"
      t.div "Feel free to test the pretty formatter"

      t.content_for(:seo) do
        t.inline_tag "meta", name: "Content-Language", value: "en"
      end
    end

    output = layout.render_as_layout(page)

    output.should eq <<-HTML
    <html>
      <head>
        <title>
          A cool page!
        </title>
        <meta name="Content-Language" value="en" >
      </head>
      <body>
        <div class="content">
          <div>
            This is the content of a page
          </div><div>
            Feel free to test the pretty formatter
          </div>
        </div>
      </body>
    </html>
    HTML
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
  it "should pretty format" do
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
end

module TreeTemplate::Components
  def my_component(x : Int32)
    div { text "This would be great #{x}!" }
  end
end

describe TreeTemplate, "usage of components" do
  it "should be easy to use components" do
    template = TreeTemplate.new do |t|
      t.my_component(5)
    end

    template.render.should eq("<div>This would be great 5!</div>")
  end
end
