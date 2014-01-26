require 'simple_stats/core_ext/enumerable'

module Enumerable
  alias frequencies_orig frequencies

  def frequencies(interval = nil, &block)
    if interval
      fs0 = self.map {|i| i - i % interval }.frequencies(&block)
      fs = {}

      (fs0.keys.min..fs0.keys.max).step(interval).each do |n|
        fs[n] = fs0[n] || 0
      end

      fs
    else
      frequencies_orig(&block)
    end
  end

  def to_gruff_labels
    labels = {}

    self.each_with_index do |label, i|
      labels[i] = label
    end

    if block_given?
      labels = Hash[*labels.select {|k, v| yield(k, v) }.flatten]
    end

    Hash[*labels.map {|k, v| [k, v.to_s] }.flatten]
  end
end
