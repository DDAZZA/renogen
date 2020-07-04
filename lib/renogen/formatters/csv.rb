# frozen_string_literal: true

module Renogen
  module Formatters
    # For formatting a change into CSV output
    class Csv < Base
      register :csv

      attr_reader :headings

      def table_formatter?
        true
      end

      def write_header(header)
        "#{header}\n"
      end

      def write_change(ticket)
        headings.map do |header|
          raw_line = ticket[header]
          next if raw_line.nil?

          parsed_line = raw_line.is_a?(Array) ? raw_line.join(',') : raw_line
          parsed_line.gsub!("\n", '\n') if parsed_line.include?("\n")

          if parsed_line.include?(',')
            "\"#{parsed_line}\""
          else
            parsed_line
          end
        end.join(',')
      end

      def header(changelog)
        @headings = changelog.groups.keys
        @headings.join(',')
      end
    end
  end
end
