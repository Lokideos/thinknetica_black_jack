# frozen_string_literal: true

module Validations
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/AbcSize
  module ClassMethods
    def validate(attr_name, validation_type, *args)
      attribute_name = attr_name.to_sym
      validation_type_name = validation_type.to_s.to_sym
      option = args[0]

      case validation_type_name
      when :presence
        define_method(validation_type_name) do
          if instance_variable_get("@#{attribute_name}".to_sym).nil? || instance_variable_get("@#{attribute_name}".to_sym) == ""
            raise "No argument was provided."
          end
        end
      when :type
        define_method(validation_type_name) do
          unless instance_variable_get("@#{attribute_name}".to_sym).class.to_s == option.to_s
            raise "Wrong type."
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/MethodLength

  module InstanceMethods
    def validate!
      presence if methods.find { |method_name| method_name == :presence }
      type if methods.find { |method_name| method_name == :type }
      true
    end

    def valid?
      validate!
    rescue StandardError
      false
    end
  end
end
