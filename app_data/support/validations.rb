# frozen_string_literal: true

module Validations
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  module ClassMethods
    attr_reader :validations
    def validate(attr_name, validation_type, *args)
      attribute_name = attr_name.to_sym
      validation_type_name = validation_type.to_s.to_sym
      method_name = "#{validation_type_name}_of_#{attribute_name}"
      option = args[0]

      @validations ||= []

      case validation_type_name
      when :presence
        define_method(method_name) do
          if instance_variable_get("@#{attribute_name}".to_sym).nil? || instance_variable_get("@#{attribute_name}".to_sym) == ""
            raise "No argument was provided."
          end
        end
        @validations << method_name
      when :type
        define_method(method_name) do
          unless instance_variable_get("@#{attribute_name}".to_sym).class.to_s == option.to_s
            raise "Wrong type."
          end
        end
        @validations << method_name
      when :format
        define_method(method_name) do
          unless instance_variable_get("@#{attribute_name}".to_sym).match? option
            raise "Wrong format of @#{attribute_name}"
          end
        end
        @validations << method_name
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/MethodLength

  module InstanceMethods
    # rubocop:disable Security/Eval
    def validate!
      self.class.validations.each { |validation| eval(validation) }
      true
    end

    # rubocop:enable Security/Eval
    def valid?
      validate!
    rescue StandardError
      false
    end
  end
end
