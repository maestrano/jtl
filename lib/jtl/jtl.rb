class Jtl
  attr_accessor :interval

  def initialize(path, interval = 1000)
    path = path.path if path.kind_of?(File)
    @jtl = CSV.read(path)
    @interval = interval
  end

  def scale_marks
    aggregate.keys
  end

  private

  def aggregate
    aggregated = {}

    @jtl.each do |row|
      ts = row[0].to_i
      ts = ts - (ts % @interval)
      ts = parse_time_stamp(ts)

      aggregated[ts] ||= []
      aggregated[ts] << row
    end

    return aggregated
  end

  def parse_time_stamp(ts)
    ts = ts.to_i
    msec = (ts % 1000)
    ts = ((ts - msec) / 1000).to_i
    Time.at(ts, msec * 1000)
  end
end
