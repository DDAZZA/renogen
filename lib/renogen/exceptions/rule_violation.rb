module Renogen
  module Exceptions
    class RuleViolation < Base
      attr_reader :file_path, :errors

      # @param file_path [String] the path to the file that violates one or more rules
      # @param errors [Array<Renogen::Rules::Validators::ValidationError>] a list of error messages
      def initialize(file_path, errors)
        @file_path = file_path
        @errors = errors
      end

      # @return [String]
      def message
        @message ||= "In file '#{file_path}':\n" << errors.map(&:message).join("\n")
      end
    end
  end
end
