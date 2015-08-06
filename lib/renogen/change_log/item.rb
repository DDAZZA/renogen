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

      # @return [String]
      def to_s
        case change.class.to_s
        when String.to_s
          format_multiline(change)
        when Hash.to_s
          format_oneline(change)
        when Array.to_s
          # TODO should return a string
          change
        else
          raise TypeError
        end
      end

      # @return [Boolean] true if change is of type array
      def list?
        change.is_a? Array
      end

      def each
        change.each do |item|
          yield item.to_s
        end
      end

      private

      def format_multiline(change)
        change.gsub('\n', '\n \n ') + "\n"
      end

      def format_oneline(change)
        # TODO Refactor
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
