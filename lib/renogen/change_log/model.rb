require 'date'

module Renogen
  module ChangeLog
    # Object to represent a Changelog/release notes
    class Model
      attr_reader :items
      attr_accessor :version, :date

      def initialize(options={})
        @version = options[:version]
        @date = options[:date] || Date.today
        @items = []
      end

      # @return [Hash<group_name: change>]
      def groups
        items.inject({}) do |hash, change|
          hash[change.group_name] ||= []
          hash[change.group_name] << change
          hash
        end
      end

      # Adds a change to the changelog
      #
      # @param change [Renogen::ChangeLog::Item]
      # @return [Array] All changes
      def add_change(change)
        raise TypeError unless change.is_a?(Renogen::ChangeLog::Item)
        items << change
      end
    end
  end
end
