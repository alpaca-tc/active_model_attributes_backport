require 'active_support/concern'
require 'active_support/core_ext/object/deep_dup'
require 'active_model/attribute_methods'

require 'active_model_attributes/version'
require 'active_model_attributes/type'

module ActiveModelAttributes
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods

  NO_DEFAULT_PROVIDED = Class.new(Object) do
    def dup; self end
  end.new.freeze

  private_constant :NO_DEFAULT_PROVIDED

  included do
    attribute_method_suffix '='
    class_attribute :_active_model_attributes_attribute_types, :_active_model_attributes_default_attributes, instance_accessor: false
    self._active_model_attributes_attribute_types = Hash.new(ActiveModelAttributes::Type.default_value)
    self._active_model_attributes_default_attributes = {}
  end

  module ClassMethods
    def attribute(name, type = ActiveModelAttributes::Type.default_value, **options)
      name = name.to_s

      if type.is_a?(Symbol)
        type = ActiveModelAttributes::Type.lookup(type)
      end

      self._active_model_attributes_attribute_types = _active_model_attributes_attribute_types.merge(name => type)

      define_default_attribute(name, options.fetch(:default, NO_DEFAULT_PROVIDED))
      define_attribute_methods(name)
    end

    private

    def define_default_attribute(name, new_value)
      self._active_model_attributes_default_attributes = _active_model_attributes_default_attributes.deep_dup.merge(name => new_value)
    end
  end

  def initialize(*)
    initialize_default_attributes
    super
  end

  private

  def initialize_default_attributes
    self.class._active_model_attributes_default_attributes.each do |name, default_value|
      initialize_default_attribute(name, default_value)
    end
  end

  def initialize_default_attribute(name, default_value)
    return if default_value == NO_DEFAULT_PROVIDED

    value = if default_value.is_a?(Proc)
              default_value.call
            else
              default_value
            end

    public_send(:"#{name}=", value)
  end

  def attribute(attr_name)
    name = if self.class.attribute_alias?(attr_name)
             self.class.attribute_alias(attr_name)
           else
             attr_name
           end

    name = name.to_s

    reader = :"@#{name}"
    instance_variable_get(reader) if instance_variable_defined?(reader)
  end

  def attribute=(attribute_name, new_value)
    type = self.class._active_model_attributes_attribute_types[attribute_name]
    value = ActiveModelAttributes::Type.cast(type, new_value)
    instance_variable_set("@#{attribute_name}", value)
  end
end
