module Renogen
  module ChangeLog
    # Object to represent single change item
    class Item
      attr_accessor :change
      attr_reader :group_name

      def initialize(group_name, change, options={})
        @group_name = group_name
        @change = change
      end

      # Coverts the item into its string representation
      #
      # @return [String]
      def to_s
        return '' unless change
        case change
        when String
          format_multiline(change)
        when Hash
          format_oneline(change)
        when Array
          format_array(change)
        else
          raise TypeError
        end
      end

      # @return [Boolean] true if change is of type array
      def list?
        change.is_a? Array
      end

      # Iterator for each item within the change
      def each
        change.each do |item|
          yield item.to_s
        end
      end

      private

      def format_multiline(change)
        change.gsub('\n', '\n \n ') + "\n"
      end

      def format_array(change)
        # TODO should return a string
        change
      end

      def format_oneline(change)
        result = single_line_format.dup

        change.select { |key, _| config.supported_keys_for(group_name).include?(key) }.each do |key, item|
          result = result.gsub(key, item)
        end

        result
      end

      def single_line_format
        format = if config.single_line_format.is_a?(Hash)
          config.single_line_format[group_name.to_sym]
        else
          config.single_line_format
        end

        format.downcase.gsub('\n', '\n  ')
      end

      def config
        Config.instance
      end
    end
  end
end
