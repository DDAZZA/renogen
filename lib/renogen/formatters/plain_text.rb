module Renogen
  module Formatters
    # For formatting a change as plain text
    class PlainText < Base
      register :plain_text
      register :text

      # Outputs a line or block of text appearing at the top of the change log.
      #
      # @param header [String]
      # @return [String]
      def write_header(header)
        "#{header}\n "
      end

      # Outputs a line or block as a header for a group.
      #
      # @param group [String]
      # @return [String]
      def write_group(group)
        "#{group}"
      end

      # Outputs a line or block as the body for a change.
      #
      # @param change [String]
      # @return [String]
      def write_change(change)
        "- #{change}"
      end
    end
  end
end
