module Renogen
  module Rules
    module Validators
      # Rule validator that ensures an item is an Array.
      #
      # Can also check the Array's items.
      class Array < Base
        # @param config [Hash]
        #
        # @return [true, false] true when config['type'] == 'Array'
        def self.handles?(config)
          'Array' == config['type']
        end

        # Validates the given item contents and returns an Array of validation errors.
        #
        # @param contents [#class]
        #
        # @return [Array<Renogen::Rules::Validators::ValidationError>]
        def validate(contents)
          type_errors = super(contents)

          return type_errors unless type_errors.empty?

          return [] unless validate_items?

          contents.map { |item| items_rule.validate(item) }.flatten(1)
        end

        def validate_items?
          config.key?('items')
        end

        # A template for new changelog items
        #
        # @return [Array]
        def template
          ['replace me']
        end

        private

        def items_rule
          @items_rule ||= obtain_rule_for(name, config['items'])
        end

        def expected_type?(contents)
          contents.is_a?(::Array)
        end

        register(self)
      end
    end
  end
end
