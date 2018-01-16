RSpec.describe ActiveModelAttributes::Type do
  let(:types) do
    if described_class::IS_RAILS_5
      rails5_0_types
    else
      rails4_2_types
    end
  end

  let(:date_time) do
    if described_class::IS_RAILS_5
      :datetime
    else
      :date_time
    end
  end

  let(:rails4_2_types) do
    {
      big_integer: ['1', 1],
      binary: ['1', '1'],
      boolean: ['1', true],
      date: ['2016-01-01', Date.parse('2016-01-01')],
      date_time => ['2016-01-01', DateTime.parse('2016-01-01')],
      decimal: ['1', 1],
      float: ['1', 1.0],
      integer: ['1', 1],
      string: ['1', '1'],
      text: ['1', '1'],
      time: ['2000/01/01 00:00:00', Time.parse('2000-01-01 00:00:00 UTC')],
    }
  end

  let(:rails5_0_types) do
    {
      big_integer: ['1', 1],
      binary: ['1', '1'],
      boolean: ['1', true],
      date: ['2016-01-01', Date.parse('2016-01-01')],
      date_time => ['2016-01-01', DateTime.parse('2016-01-01')],
      decimal: ['1', 1],
      float: ['1', 1.0],
      integer: ['1', 1],
      string: ['1', '1'],
      time: ['2000/01/01 00:00:00', Time.parse('2000-01-01 00:00:00 UTC')],
    }
  end

  describe '.cast_value' do
    it 'cast value to type' do
      types.each do |key, (from, to)|
        type = described_class.lookup(key)
        expect(described_class.cast(type, from)).to eq(to)
      end
    end
  end
end
