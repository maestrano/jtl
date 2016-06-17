# jtl

Parse a default jtl file of [Apache JMeter](http://jmeter.apache.org/).

## Installation

Add this line to your application's Gemfile:

    gem 'jtl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jtl

## Usage

```ruby
require 'jtl'
require 'gruff'

jtl = Jtl.new('jmeter.jtl', interval: 10_000)

g_line = Gruff::Line.new

g_line.title = 'elapsed (avg)'
g_line.labels = jtl.scale_marks.map {|i| i.strftime('%M:%S') }.to_gruff_labels

g_line.data :all, jtl.elapseds {|i| i.mean }
g_line.data :my_label1, jtl.elapseds.my_label1 {|i| i.mean }
g_line.data :my_label2, jtl.elapseds.my_label2 {|i| i.mean }

g_line.write('elapsed.png')

jtl = jtl.flatten
fs = jtl.elapseds.frequencies(10)

g_bar = Gruff::Bar.new
g_bar.title = 'histogram'
g_bar.labels = fs.keys.to_gruff_labels {|k, v| (v % 100).zero? }
g_bar.data :elapsed, fs.values

g_line.write('histogram.png')
```
