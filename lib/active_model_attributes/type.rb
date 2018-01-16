require 'active_model'

module ActiveModelAttributes
  module Type
    IS_RAILS_5 = defined?(ActiveModel) && ActiveModel.gem_version >= Gem::Version.new('5.0.0')

    if IS_RAILS_5
      require 'active_model_attributes/type/rails5'
      include(Type::Rails5)
    else
      require 'active_model_attributes/type/rails4'
      include(Type::Rails4)
    end
  end
end
