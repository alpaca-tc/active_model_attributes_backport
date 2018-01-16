require 'active_model/type'

module ActiveModelAttributes
  module Type
    module Rails5
      extend ActiveSupport::Concern

      module ClassMethods
        def lookup(symbol)
          ActiveModel::Type.lookup(symbol)
        end

        def cast(type, value)
          type.cast(value)
        end

        def default_value
          @default_value ||= ActiveModel::Type::Value.new
        end
      end
    end
  end
end
