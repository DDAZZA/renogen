module Renogen
  module ChangeLog
    # Object to represent single change item
    class Item
      attr_accessor :change
      attr_reader :group_name, :ticket_id

      def initialize(ticket_id, group_name, change, options={})
        @ticket_id = ticket_id
        @group_name = group_name
        @change = change
      end

      # Coverts the item into its string representation
      #
      # @return [String]
      def to_s
        return '' unless change

        case change.class.to_s
        when 'String'
          format_multiline(change)
        when 'Hash'
          format_oneline(change)
        when 'Array'
          format_array(change)
        else
          raise TypeError
        end
      end

      # @return [Boolean] true if change is of type array
      def list?
        change.is_a? Array
      end

      # Iterater for each item within the change
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
        # TODO: should return a string
        change
      end

      def format_oneline(change)
        # TODO: Refactor
        string = config.single_line_format.downcase.gsub('\n', '\n  ')
        config.supported_keys.each do |key|
          string = string.gsub(key, '#{change[\'' + key + '\']}')
        end
        ss = "\"#{string}\""
        eval(ss)
      end

      def config
        Config.instance
      end
    end
  end
end
