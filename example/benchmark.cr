require "benchmark"
require "../src/tree_template"

users = [
  {name: "Yacine", id: 1},
  {name: "Victor", id: 2},
  {name: "Roger", id: 3},
  {name: "Marlo", id: 4},
  {name: "Luis", id: 5},
]

def render_user(t, user)
  t.div "class": ["user", "block"], "data": {id: user[:id]} do
    t.div(user[:name])
  end
end

def render_nav(t)
  t.nav rel: "main-nav", class: "navigation", id: "nav" do
    t.ul id: "nav-menu" do
      t.li(class: "nav-item") { t.a("Home", href: "#") }
      t.li(class: "nav-item") { t.a("Manage users", href: "#") }
      t.li(class: "nav-item") { t.a("Login", href: "#") }
      t.li(class: "nav-item") { t.a("Logout", href: "#") }
    end
  end
end

my_template = TreeTemplate.new(directive: :html5) do |t|
  t.html do
    render_nav(t)
    t.body do
      users.each do |user|
        render_user(t, user)
      end
    end
  end
end

Benchmark.ips do |x|
  x.report("render template") do
    my_template.render
  end
end
