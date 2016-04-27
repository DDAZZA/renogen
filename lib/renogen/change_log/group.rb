module Renogen
  module ChangeLog
    # Object to represent a group of changes
    class Group
      attr_reader :name, :changes

      def initialize(group_name)
        @name = group_name
        @changes ||= []
      end

      # Add change to the groups change list
      #
      # @param new_change [ChangeLog::Item]
      def add(new_change)
        @changes << new_change
      end
    end
  end
end
