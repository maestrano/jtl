class Jtl::LabeledValue
  attr_reader :label
  attr_reader :value

  def initialize(label, value)
    @label = label
    @value = value
  end
end
