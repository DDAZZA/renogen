module Renogen
  module Rules
    # Represents a rule for a single change file (that may contain entries for multiple groups)
    #
    # @example [config file]
    #   rules:
    #     files:
    #       /.+/:
    #         keys: # type: Hash is implicit
    #           required:
    #           - Summary
    #           optional:
    #           - Details
    #           - Tasks
    #     groups:
    #       Summary:
    #         type: Hash
    #         keys:
    #           required:
    #           - Summary
    #           - Link
    #           - Requires
    #         items:
    #           Requires:
    #             type: Boolean
    #           :*:
    #             type: String
    #       Details:
    #         type: String
    #       Tasks:
    #         type: Array
    #         items:
    #           type: Hash
    #           keys:
    #             required:
    #             - Migrations
    #             - Rake
    #           items:
    #             :*:
    #               type: String
    #
    class File
      attr_reader :file_path_pattern, :config

      # Validates the given file contents for a given path
      #
      # @param file_path [String] the file path to use in error messages
      # @param file_contents [Hash] the contents of the file as Hash
      #
      # @raise RuntimeError
      def self.validate!(file_path, file_contents)
        errors = []

        errors.concat(validate_root_keys(file_path, file_contents))

        errors.concat(validate_groups(file_contents))

        raise Renogen::Exceptions::RuleViolation.new(file_path, errors) unless errors.empty?
      end

      # @param file_path_pattern [String] a pattern (see File.fnmatch) that matches the files for the given rule
      #                                   configuration
      # @param config [Hash] the rule configuration which depends on the rule type - specified by the 'type' key
      def initialize(file_path_pattern, config)
        @file_path_pattern = file_path_pattern

        config['type'] = 'Hash'
        @config = config
      end

      # Check for equality
      #
      # @param other [Object]
      #
      # @return [true, false] true when file_path_pattern and config of self and other are equal
      def ==(other)
        other.respond_to?(:file_path_pattern) &&
          other.respond_to?(:config) &&
          file_path_pattern == other.file_path_pattern &&
          config == other.config
      end

      # Validates the given (yaml file) contents
      #
      # @param file_contents [Hash] the parsed YAML file
      #
      # @return [Array<Renogen::Rules::Validators::ValidationError>]
      def validate(file_contents)
        validate_root_keys(file_contents)
      end

      private

      def self.config
        ::Renogen::Config.instance
      end

      # @return [Hash]
      def self.file_rules
        config.file_rules
      end

      def self.validator_for(file_path)
        key = file_rules.keys.find { |pattern| ::File.fnmatch(pattern, file_path) }

        return nil unless key

        file_rules[key]
      end

      def self.validate(validator, contents)
        if validator
          validator.validate(contents)
        else
          []
        end
      end

      def self.validate_root_keys(file_path, file_contents)
        validate(validator_for(file_path), file_contents)
      end

      def self.validate_groups(file_contents)
        file_contents.each_with_object([]) do |group_array, errors|
          errors.concat(validate_group(*group_array))
        end
      end

      def self.validate_group(group_name, group_contents)
        validate(Group.validator_for(group_name), group_contents)
      end

      def validate_root_keys(file_contents)
        root_key_validator.validate(file_contents)
      end

      def root_key_validator
        @root_key_validator ||= Validators::Hash.new('', config)
      end
    end
  end
end
