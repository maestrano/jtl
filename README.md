# jtl

Parse the default jtl file of [Apache JMeter](http://jmeter.apache.org/).

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

jtl = Jtl.new('jmeter.jtl', 10_000)
#                           ~~~~~~~ interval: 10s (default: 1s)

g = Gruff::Line.new

g.title = 'elapsed (avg)'
marks = jtl.scale_marks.map {|i| i.strftime('%M:%S') }
g.labels = Hash[*(0...marks.length).zip(marks).flatten]

g.data :all,  jtl.elapseds {|i| i.mean }
g.data :my_label1, jtl.elapseds.my_label1 {|i| i.mean }
g.data :my_label2, jtl.elapseds.my_label2 {|i| i.mean }

g.write('elapsed.png')
```
