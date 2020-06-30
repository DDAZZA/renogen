# frozen_string_literal: true

module Renogen
  module Writers
    # Writes out the change log in CSV format
    class Csv < Base
      register :csv

      def write!(changelog)
        puts formatter.write_headings(changelog)
        output_files(changelog)
      end

      private

      def output_files(changelog)
        changelog.files.each do |file|
          puts formatter.write_file(file, changelog)
        end
      end
    end
  end
end
