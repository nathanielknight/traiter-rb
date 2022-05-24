require_relative "../storylet"

def changes(&b)
  c = Changes.new
  c.define(&b)
end

c = changes do
  set("foo", text: "Hi there!")
  set("bar", number: 8)

  unset("dingus")

  gain(2, "Fooz")
  lose(3, "Barbells")
end

puts(c.inspect)
