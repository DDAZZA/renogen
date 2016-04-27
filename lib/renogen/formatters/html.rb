module Renogen
  module Formatters
    # For formatting a change into html format
    class Html < Base
      register :html

      # Outputs a line or block of text appearing at the top of the change log.
      #
      # @param header [String]
      # @return [String]
      def write_header(header)
        "<html>\n<h1>#{header}</h1>"
      end

      # Outputs a line or block as a header for a group.
      #
      # @param group [String]
      # @return [String]
      def write_group(group)
        "<h2>#{group}</h2>\n<ul>"
      end

      # Outputs a line or block of text appearing after a group.
      #
      # @return [String]
      def write_group_end
        '</ul>'
      end

      # Outputs a line or block as the body for a change.
      #
      # @param change [String]
      # @return [String]
      def write_change(change)
        "  <li>#{change}</li>"
      end

      # Outputs a line or block of text appearing at the bottom of the change log.
      #
      # @param changelog [ChangeLog]
      # @return [String]
      def write_footer(_changelog)
        '</html>'
      end
    end
  end
end
