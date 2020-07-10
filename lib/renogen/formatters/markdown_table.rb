module Renogen
  module Formatters
    # For formatting a change into markdown format
    class MarkdownTable < Markdown
      register :markdown_table
      register :md_table

      attr_reader :headings

      def table_formatter?
        true
      end

      # Generate header
      #
      # @param changelog [Renogen::ChangeLog::Model]
      #
      # return [String]
      def header(changelog)
        @headings = changelog.groups.keys
        [
          "# #{changelog.version} (#{changelog.date})",
          "",
          "| #{headings.join(' | ')} |",
          "| #{headings.map{|_| '-' }.join(' | ')} |"
        ].join("\n")
      end

      # Outputs a line or block of text appearing at the top of the change log.
      #
      # @param header [String]
      # @return [String]
      def write_header(header)
        "#{header}\n"
      end

      # Outputs a line or block as a header for a group.
      #
      # @param group [String]
      # @return [String]
      def write_group(group)
        "## #{group}\n\n"
      end

      # Outputs a line or block as the body for a change in a group.
      #
      # @param ticket [Hash<group: string>]
      # @return [String]
      def write_change(ticket)
        "| "+ @headings.map do |heading|
          value = ticket.fetch(heading, '-')
          value = value.join("\n") if value.is_a?(Array)
          value.gsub("\n", "<br>")
        end.join(' | ') + " |"
      end
    end
  end
end
