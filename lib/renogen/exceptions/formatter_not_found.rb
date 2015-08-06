module Renogen
  module Exceptions
    # Raised when an extraction stratagy for a given key can not be found
    class FormatterNotFound < Base
      attr_reader :name

      def initialize(name)
        @name = name
        super
      end

      # Friendly error message
      #
      # @return [String]
      def message
        "Error: Unsupported format type '#{name}'"
      end
    end
  end
end
