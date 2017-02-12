module Renogen
  module Rules
    module Validators
      # Rule validator that ensures an item is an Hash
      #
      # Can also check the Hash items with a per-key or global configuration.
      class Hash < Base
        # @param config [Hash]
        #
        # @return [true, false] true when config['type'] == 'Hash'
        def self.handles?(config)
          'Hash' == config['type']
        end

        # Validates the given hash against the configured constraints
        #
        # @param contents [#class]
        #
        # @return [Array<Renogen::Rules::Validators::ValidationError>]
        def validate(contents)
          type_errors = super(contents)

          return type_errors unless type_errors.empty?

          validate_keys_for(contents) + validate_items_in(contents)
        end

        # @return [Array<String>] a list of keys that are required to pass the rule
        def required_keys
          @required_keys ||= config.dig('keys', 'required')&.uniq || []
        end

        # @return [Array<String>] a list of keys that are optional for this rule
        def optional_keys
          @optional_keys ||= config.dig('keys', 'optional')&.uniq || []
        end

        # @return [Array<String>] a list of required and optional keys for this rule
        def supported_keys
          (required_keys + optional_keys).uniq
        end

        def validate_keys?
          config.key?('keys')
        end

        def validate_items?
          config.key?('items')
        end

        private

        def validate_keys_for(contents)
          if validate_keys?
            validate_required_keys_for(contents) + validate_supported_keys_for(contents)
          else
            []
          end
        end

        def validate_required_keys_for(contents)
          (required_keys - contents.keys).map do |missing_key|
            ValidationError.new(message: "Missing required key '#{missing_key}' for '#{name}'", rule: self)
          end
        end

        def validate_supported_keys_for(contents)
          (contents.keys - supported_keys).map do |unexpected_key|
            ValidationError.new(message: "Unexpected key '#{unexpected_key}' in '#{name}'", rule: self)
          end
        end

        def validate_items_in(contents)
          return [] unless validate_items?

          contents.each_with_object([]) do |item_array, errors|
            errors.concat(validate_item(*item_array))
          end
        end

        def validate_item(item_name, item_contents)
          rule_config = config.dig('items', item_name) || config.dig('items', :'*')

          return [] unless rule_config

          obtain_rule_for(item_name, rule_config).validate(item_contents)
        end

        def expected_type?(contents)
          contents.is_a?(::Hash)
        end

        register(self)
      end
    end
  end
end
