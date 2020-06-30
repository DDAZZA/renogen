# frozen_string_literal: true

module Renogen
  module ChangeLog
    # Validates the change log
    class Validator
      def initialize(formatter)
        @formatter = formatter
        @validations = formatter.options['allowed_values']
      end

      # Validates the change log
      #
      # @param changelog [ChangeLog::Model]
      def validate!(changelog)
        validate_headings(changelog)
      end

      protected

      attr_reader :formatter, :validations

      def validate_headings(changelog)
        return if validations.nil?
        return if changelog.items.none? { |item| validations.key?(item.group_name) }

        validate_properties(changelog)
      end

      private

      def validate_properties(changelog)
        invalid_items = []
        validations.each do |heading, values|
          items_to_select = changelog.items.select { |log| log.group_name == heading }
          invalid_values = items_to_select.map do |i|
            changes = changes_to_validate(i.change)
            next changes - values if values.is_a?(Array)
            next unless values.is_a?(Regexp)

            changes.detect { |c| c !~ values } # return anything that does not match the regexp.
          end

          invalid_values = invalid_values.flatten.compact.uniq # remove duplicates and nils
          next if invalid_values.empty?

          invalid_items << { invalid_value: invalid_values, valid_values: values, group_name: heading }
        end

        invalid_items = invalid_items.flatten
        raise(Renogen::Exceptions::InvalidItemFound, invalid_items) unless invalid_items.empty?
      end

      def changes_to_validate(change)
        return [change] if change.is_a? String

        change
      end
    end
  end
end
