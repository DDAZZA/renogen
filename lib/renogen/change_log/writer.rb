module Renogen
  module ChangeLog
    # Writes out the change log
    class Writer
      def initialize(formatter)
        @formatter = formatter
      end

      # Writes out the change log
      #
      # @param changelog [ChangeLog::Model]
      def write!(changelog)
        puts formatter.write_header(changelog.header)
        output_groups(changelog.groups)
        puts formatter.write_footer(changelog)
      end

      protected

      attr_reader :formatter

      def output_change(change)
        if change.list?
          change.each { |item| puts formatter.write_change(item) }
        else
          puts formatter.write_change(change.to_s) if change.to_s.size > 0
        end
      end

      def output_groups(groups)
        groups.each do |group, changes|
          puts formatter.write_group(group)
          changes.each { |change| output_change(change) }
          puts formatter.write_group_end
        end
      end
    end
  end
end
