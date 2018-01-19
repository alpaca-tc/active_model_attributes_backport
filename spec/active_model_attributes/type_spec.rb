RSpec.describe ActiveModelAttributes::Type do
  let(:date_time) do
    if ActiveModelAttributes::Utils.rails5?
      :datetime
    else
      :date_time
    end
  end

  let(:text_type) do
    if ActiveModelAttributes::Utils.rails5?
      :string
    else
      :text
    end
  end

  let(:types) do
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
      text_type => ['1', '1'],
      time: ['2000/01/01 00:00:00', Time.parse('2000-01-01 00:00:00 UTC')],
    }
  end

  describe '.lookup' do
    context 'when type exist' do
      it 'finds then instance of type from symbol' do
        types.keys.each do |type|
          expect(described_class.lookup(type)).to be_present
        end
      end
    end

    context "when type doesn't exist" do
      it { expect { described_class.lookup(:unknown) }.to raise_error(ArgumentError) }
    end
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
