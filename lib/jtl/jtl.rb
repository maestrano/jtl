class Jtl
  attr_accessor :interval

  COLUMNS = [
    :time_stamp,
    :elapsed,
    :label,
    :response_code,
    :response_message,
    :thread_name,
    :data_type,
    :success,
    :bytes,
    :url,
    :latency,
  ]

  def initialize(path, interval = 1000)
    path = path.path if path.kind_of?(File)
    @jtl = CSV.read(path)
    @interval = interval
  end

  def labels
    @jtl.inject({}) {|r, i| r[label(i)] = true; r }.keys
  end

  def scale_marks
    aggregate_rows.keys
  end

  def time_stamps(&block)
    data_set = aggregate_by(:time_stamp) {|v| v.to_i }
    DataSet.create(data_set, self, &block)
  end

  def response_codes(&block)
    data_set = aggregate_by(:response_code) {|v| v.to_i }
    DataSet.create(data_set, self, &block)
  end

  def thread_names(&block)
    data_set = aggregate_by(:thread_name)
    DataSet.create(data_set, self, &block)
  end

  def response_messages(&block)
    data_set = aggregate_by(:response_message)
    DataSet.create(data_set, self, &block)
  end

  def elapseds(&block)
    data_set = aggregate_by(:elapsed) {|v| v.to_i }
    DataSet.create(data_set, self, &block)
  end

  private

  def aggregate_by(column)
    idx = COLUMNS.index(column)
    aggregated = OrderedHash.new

    aggregate_rows.each do |mark, rows|
      aggregated[mark] = rows.map do |row|
        value = row[idx]
        value = yield(value) if block_given?
        LabeledValue.new(label(row), value)
      end
    end

    return aggregated
  end

  def aggregate_rows
    aggregated = OrderedHash.new

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

  def label(row)
    @label_index = COLUMNS.index(:label) unless @label_index
    row[@label_index]
  end
end
