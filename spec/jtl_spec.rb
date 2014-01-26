describe Jtl do
  let(:jtl_path) do
    File.expand_path('../test.jtl', __FILE__)
  end

  let(:jtl_range) do
    1390719751491..1390719811195
  end

  it 'scale_marks (defaut)' do
    jtl = Jtl.new(jtl_path)
    marks = jtl_range.map {|i| Time.at((i - i % 1000) / 1000) }.uniq.sort
    expect(jtl.scale_marks).to eq(marks)
  end

  it 'scale_marks (10s)' do
    jtl = Jtl.new(jtl_path, 10000)
    marks = jtl_range.map {|i| Time.at((i - i % 10000) / 1000) }.uniq.sort
    expect(jtl.scale_marks).to eq(marks)
  end
end
