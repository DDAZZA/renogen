# frozen_string_literal: true

module Renogen
  module Exceptions
    # Raised when change log contains invalid items.
    class InvalidItemFound < Base
      attr_reader :invalid_items

      def initialize(invalid_items)
        @invalid_items = invalid_items
        super
      end

      # Friendly error message
      #
      # @return [String]
      def message
        messages = ['Invalid items:']
        invalid_items.each do |item|
          invalid_value = item[:invalid_value]

          messages << if item[:valid_values].is_a?(Regexp)
            "Group: #{item[:group_name]}, Content: #{invalid_value}, Pattern: #{item[:valid_values].inspect}"
          else
            "Group: #{item[:group_name]}, Content: #{invalid_value}, Valid Values: #{item[:valid_values]}"
          end
        end
        messages.join("\n")
      end
    end
  end
end
