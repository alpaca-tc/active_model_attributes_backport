module ActiveModelAttributes
  module Utils
    def self.rails5?
      defined?(::ActiveModel) && ::ActiveModel.gem_version >= Gem::Version.new('5.0.0')
    end
  end
end
