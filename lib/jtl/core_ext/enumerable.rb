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
end
