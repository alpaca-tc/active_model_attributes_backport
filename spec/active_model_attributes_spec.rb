RSpec.describe ActiveModelAttributes do
  context '.attribute' do
    let(:date_time) do
      if described_class::Type::IS_RAILS_5
        :datetime
      else
        :date_time
      end
    end

    let(:types) do
      {
        boolean: ['1', true],
        date: ['2016-01-01', Date.parse('2016-01-01')],
        date_time => ['2016-01-01', Time.utc('2016-01-01')],
        float: ['1', 1.0],
        integer: ['1', 1],
        string: ['1', '1'],
        time: ['2000/01/01 00:00:00', Time.parse('2000-01-01 00:00:00 UTC')],
      }
    end

    let(:instance) { klass.new }

    context 'called attribute' do
      let(:klass) do
        target = Class.new

        target.class_exec(types) do |type_with_value|
          include(ActiveModelAttributes)

          type_with_value.keys.each do |type|
            attribute(type, type)
          end
        end

        target
      end

      it 'cast value to type' do
        types.each do |key, (from, to)|
          expect(instance.public_send(key)).to be_nil
          instance.public_send("#{key}=", from)
          expect(instance.public_send(key)).to eq(to)
        end
      end
    end

    context 'called attribute and overwrite defined method' do
      let(:klass) do
        target = Class.new

        target.class_exec(types) do |type_with_value|
          include(ActiveModelAttributes)

          type_with_value.keys.each do |type|
            attribute(type, type)

            class_eval <<~METHOD, __FILE__, __LINE__ + 1
              def #{type}
                super.class
              end
            METHOD
          end
        end

        target
      end

      it 'cast value to class' do
        types.each do |key, (from, to)|
          expect(instance.public_send(key)).to eq(NilClass)
          instance.public_send("#{key}=", from)
          expect(instance.public_send(key)).to eq(to.class)
        end
      end
    end

    context 'called attribute with attribute name' do
      let(:klass) do
        Class.new do
          include ActiveModelAttributes

          attribute :no_type
        end
      end

      it 'returns original value' do
        expect(instance.no_type).to be_nil

        value = Object.new
        instance.no_type = value

        expect(instance.no_type).to eq(value)
      end
    end

    context 'called attribute with original type' do
      let(:type_klass) do
        if described_class::Type::IS_RAILS_5
          Class.new(ActiveModel::Type::Value) do
            def cast(*)
              'original'
            end
          end
        else
          Class.new(ActiveRecord::Type::Value) do
            def type_cast_from_user(*)
              'original'
            end
          end
        end
      end

      let(:klass) do
        new_klass = Class.new do
          include ActiveModelAttributes
        end

        new_klass.attribute :original, type_klass.new
        new_klass
      end

      it 'returns original value' do
        expect(instance.original).to be_nil

        value = Object.new
        instance.original = value

        expect(instance.original).to eq('original')
      end
    end

    context 'called attribute with default value' do
      let(:klass) do
        Class.new do
          include ActiveModelAttributes

          attribute :string, :string, default: 1
          attribute :proc, :string, default: -> { 2 }
        end
      end

      it 'assigns default value on initialize' do
        expect(instance.string).to eq('1')
        expect(instance.proc).to eq('2')
      end

      context 'overwrite default attribute' do
        let(:klass) do
          parent = super()

          Class.new(parent) do
            attribute :string, :string
            attribute :proc, :string, default: '3'
          end
        end

        it 'overwrites default attribute' do
          expect(instance.string).to be_nil
          expect(instance.proc).to eq('3')
        end
      end
    end
  end
end
