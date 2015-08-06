module Renogen
  module Exceptions
    # Raised when an extraction stratagy for a given key can not be found
    class ExtractionStratagyNotFound < Base
      attr_reader :missing_stratagy

      def initialize(type)
        @missing_stratagy = type
        super
      end

      # Friendly error message
      #
      # @return [String]
      def message
        "Error: Unsupported source type '#{missing_stratagy}'"
      end
    end
  end
end
