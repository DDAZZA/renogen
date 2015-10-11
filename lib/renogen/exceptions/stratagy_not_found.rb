module Renogen
  module Exceptions
    # Raised when an extraction stratagy for a given key can not be found
    class StratagyNotFound < Base
      attr_reader :missing_stratagy

      def initialize(type)
        @missing_stratagy = type
        super
      end

      # Friendly error message
      #
      # @return [String]
      def message
        "Error: Stratagy type '#{missing_stratagy}' not found"
      end
    end
  end
end
