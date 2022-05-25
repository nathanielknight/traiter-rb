require_relative "../storylet"

def outcome(&b)
  o = Outcome.new
  o.define(&b)
end

o = outcome do
  body(
    <<-E
  Onc there was a way to get back home.
E
    )

  goto(:foobaz)

  changes do
    set(:foo, number: 3)
    gain(2, :xp)
    lose(1, :hp)
  end
end

puts(o.inspect)
