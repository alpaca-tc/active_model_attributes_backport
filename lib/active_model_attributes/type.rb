require 'active_model'

module ActiveModelAttributes
  module Type
    if ActiveModelAttributes::Utils.rails5?
      require 'active_model_attributes/type/rails5'
      include(ActiveModelAttributes::Type::Rails5)
    else
      require 'active_model_attributes/type/rails4'
      include(ActiveModelAttributes::Type::Rails4)
    end
  end
end
