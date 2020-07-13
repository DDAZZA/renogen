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
        puts formatter.write_header(formatter.header(changelog)) unless formatter.write_header(formatter.header(changelog)).nil?
        if formatter.table_formatter?
          write_by_table!(changelog)
        else
          write_by_group!(changelog)
        end
        puts formatter.write_footer(changelog) unless formatter.write_footer(changelog).nil?
      end

      # Writes out the change log by group
      #
      # @param changelog [ChangeLog::Model]
      def write_by_group!(changelog)
        output_groups(changelog.groups)
      end

      # Writes out the change log by item
      #
      # @param changelog [ChangeLog::Model]
      def write_by_table!(changelog)
        changelog.tickets.each do |_, ticket|
          puts formatter.write_change(ticket)
        end
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
          deduped_changes(changes).each { |change| output_change(change) }
          puts formatter.write_group_end
        end
      end

      def deduped_changes(changes)
        return changes unless config.remove_duplicates

        changes.uniq { |c| c.to_s }
      end

      private

      def config
        Config.instance
      end
    end
  end
end
