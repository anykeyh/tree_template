# TreeTemplate

Just a HTML templating system for Crystal, which is not using any templating language
but Crystal itself instead.

This is a revamp of [html_builder](https://github.com/crystal-lang/html_builder)
built-in `crystal` core lib itself.
I thought it was a good idea but the version in the framework is still very limited
for now.


## Install

Add this to your `shard.yml` then `crystal deps`

```yaml
  dependencies:
    tree_template:
      github: anykeyh/tree_template
```

## Usage

```crystal
  template = TreeTemplate.new do |t|
    t.body do
      t.section id: "main-section" do
        t.ul id: "main-nav", class: "main-nav" do
          t.li{ t.a "Home", href: "#" }
          t.li{ t.a "Articles", href: "#" }
          t.li{ t.a "Sign-in", href: "#" }
        end
      end
    end
  end

  puts template.render
```

It's pretty straight forward.

## Limitation / choices

### Partial/Components

There's nothing yet for render partial and/or component. But this can be done easily:

```crystal
  def my_partial t, user: User
    t.div class: "user-block" do
      t.span user.name, class: "user-name"
    end
  end
```

Then in your layout:

```crystal
  @user = xxx
  #...
  template = TreeTemplate.new do |t|
    t.body do
      my_partial(t, @user)
    end
  end
```

### Text rendering

Text rendering can use `t.xxx(text, **attributes)` or `t.xxx(**attributes){ t.text "xxx" } `

You can't use both at the same time.

### Auto-closing markup

The standard HTML autoclosing markup (input, meta...) are supported.

Therefore, typing `t.input{ t.text "xxx" }` will raise an error

### XML

I'm pretty sure the complex flavors of XML are not supported yet.
Just extend and fork if needed :)

## Advanced options

### Changing root (default: 'html')

```crystal
  template = TreeTemplate.new(root: "div") do |t|
    # ...
  end
```


### Directives

```crystal
  # directive `<!DOCTYPE>` can be written using a existing template via `symbol`
  # or writting itself the full directive via `string`

  template = TreeTemplate.new(directive: :html5) do |t|
    # ...
  end

  # or
  template = TreeTemplate.new(directive: "<!DOCTYPE ...>") do |t|
    # ...
  end

```

### Renderer

By default, the used renderer is the `PrettyRenderer`, which prettify your HTML
making it easy to read for human.
It can led to small issues with `<textarea>` as space before and after the
text content will be display in the textarea.

A compact renderer exist and will render without any space, saving few bytes and
operations, and would be great for production build.

```crystal
  template = TreeTemplate.new(renderer: TreeTemplate::CompactRenderer.new) do |t|
    # ...
  end

  # or

  # Change the default renderer in production mode only
  {% if env("production") %}
    TreeTemplate.default_renderer = TreeTemplate::CompactRenderer.new
  {% end %}
```

### What's next

- I'm going to write more tests to ensure all works perfectly
- Providing of a real templating/component/layout system ?

### License

MIT Licence. Fork it and have fun !
Let's make Crystal ecosystem as great as the Ruby one !