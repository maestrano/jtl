class Jtl::DataSet
  include Enumerable

  def self.create(data_set)
    obj = self.new(data_set)

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

    @data_set.each do |mark, values|
      new_data_set[mark] = values.select do |lv|
        if label.kind_of?(Regexp)
          lv.label =~ label
        else
          lv.label == label.to_s
        end
      end
    end

    self.class.create(new_data_set, &block)
  end

  def each
    @data_set.each do |mark, values|
      yield(values.map {|lv| lv.value})
    end
  end

  def method_missing(name, *args, &block)
    if (ary = self.to_a).respond_to?(name)
      ary.send(name, *args, &block)
    elsif args.empty?
      self[name.to_s, &block]
    else
      super
    end
  end
end
