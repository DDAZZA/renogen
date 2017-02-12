module Renogen
  module Rules
    # Validators for defined rules
    module Validators
      # Obtains a validator for the given rule configuration.
      #
      # @param name [String] The group or key name for which the rule configuration is applied
      # @param config [Hash] The rule configuration
      #
      # @return [Renogen::Rules::Validators::Base] or a more specific validator implementation
      def self.obtain(name, config)
        validator_klass = registered_validators.find { |validator| validator.handles?(config) }

        unless validator_klass
          $stderr.puts "Using fallback validator for '#{name}'. Check 'type' config key."
          validator_klass = Validators::Base
        end

        validator_klass.new(name, config)
      end

      # Registers a rule validator class
      #
      # @param validator [Class]
      def self.register(validator)
        registered_validators << validator unless registered_validators.include?(validator)
      end

      # Returns a registered rule validator classes
      #
      # @return [Array<Class>]
      def self.registered_validators
        @registered_validators ||= []
      end

      require_relative 'validators/validation_error'
      require_relative 'validators/base'
      require_relative 'validators/array'
      require_relative 'validators/hash'
      require_relative 'validators/boolean'
      require_relative 'validators/string'
    end
  end
end
