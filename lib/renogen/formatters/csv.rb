# frozen_string_literal: true

module Renogen
  module Formatters
    # For formatting a change into CSV output
    class Csv < Base
      register :csv

      def write_headings(changelog)
        headers(changelog).join(',')
      end

      def write_file(file, changelog)
        output = []

        headers(changelog).each do |header|
          raw_line = file[header]
          parsed_line = raw_line.is_a?(Array) ? raw_line.join(',') : raw_line
          output << "\"#{parsed_line}\""
        end

        output.join(',')
      end

      private

      def headers(changelog)
        changelog.groups.keys
      end
    end
  end
end
