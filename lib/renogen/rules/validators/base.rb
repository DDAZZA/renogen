module Renogen
  module Rules
    module Validators
      # Base validator for rules
      class Base
        attr_reader :name, :config

        # @param name [String] the item or group name
        # @param config [Hash] the rule configuration
        def initialize(name, config)
          @name = name
          @config = config
        end

        # @param other [Object]
        #
        # @return [true, false] true when name and config of self and other are equal
        def ==(other)
          other.respond_to?(:name) && other.respond_to?(:config) && name == other.name && config == other.config
        end

        # Validates the given item contents and returns an Array of validation errors
        #
        # @param contents [#class]
        #
        # @return [Array<Renogen::Rules::Validators::ValidationError]
        def validate(contents)
          validate_type_for(contents)
        end

        def validate_type?
          config.key?('type')
        end

        # Template for new changelog items that adhere to this rule
        #
        # @return [String]
        def template
          ''
        end

        private

        def self.register(klass)
          ::Renogen::Rules::Validators.register(klass)
        end

        def obtain_rule_for(name, config)
          ::Renogen::Rules::Validators.obtain(name, config)
        end

        def validate_type_for(contents)
          if validate_type? && !expected_type?(contents)
            [
              ValidationError.new(
                message: "Expected '#{name}' to be a #{config['type']}, but found a #{contents.class.name}",
                rule: self)
            ]
          else
            []
          end
        end

        def expected_type?(contents)
          contents.class.name == config['type']
        end
      end
    end
  end
end
