class Jtl::DataSet
  include Enumerable

  def self.new(data_set)
    obj = super

    if block_given?
      obj.to_a.map {|i| yield(i) }
    else
      obj
    end
  end

  def initialize(data_set)
    @data_set = data_set
  end

  def [](label, &block)
    new_data_set = OrderedHash.new

    @deta_set.each do |mark, values|
      new_data_set[mark] = values.select do |lv|
        if label.kind_of?(Regexp)
          lv.label =~ label
        else
          lv.label == label.to_s
        end
      end
    end

    self.class.new(new_data_set, &block)
  end

  def each
    @data_set.each do |mark, values|
      yield(values.map {|lv| lv.value})
    end
  end

  def method_missing(name, *args, &block)
    if args.zero?
      self[name.to_s, &block]
    else
      super
    end
  end
end
