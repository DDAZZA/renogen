require 'date'

module Renogen
  module ChangeLog
    # Object to represent a Changelog/release notes
    class Model
      attr_reader :items, :files
      attr_accessor :version, :date

      def initialize(options={})
        @version = options[:version]
        @date = options[:date] || Date.today
        @items = []
        @files = []
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

      # Adds a raw YAML file hash to the changelog
      #
      # @param file [Hash]
      # @return [Array] All files
      def add_file(file)
        raise TypeError unless file.is_a?(Hash)
        files << file
      end
    end
  end
end
