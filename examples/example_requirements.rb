require_relative "../storylet"

def requirements(&block)
  requirements = Requirements.new
  requirements.define(&block)
  requirements
end

rs = requirements do
  eq("Foo", text: "Bar")
  eq("Bar", number: 3)
  eq("Zing", number: 4, text: 11)

  less_than("Faasdf", 22)
end

puts(rs.inspect)
