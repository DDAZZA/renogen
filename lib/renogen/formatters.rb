module Renogen
  # Formatters to manipulate how the change is output
  #
  # Also has methods to retrive and add a formatters
  module Formatters

    class << self
      # Retrieves a formatter from a given key
      #
      # @param format_type [String] identifier for formatter
      # @param options [Hash] any options required for formatter
      # @return [Formatter::Base]
      def obtain(format_type, options={})
        formatter = formatters[format_type.to_sym]
        if formatter
          formatter.new(options)
        else
          raise Renogen::Exceptions::StratagyNotFound.new(format_type)
        end
      end

      # Adds a new formatter class to store
      #
      # @param identifier [Symbol]
      # @param klass [Symbol]
      def add(identifier, klass)
        # raise 'name taken' unless formatters[name].nil?
        formatters[identifier]=klass
      end

      private

      def formatters
        @formatters ||= {}
      end
    end
  end

  require_relative 'formatters/base'
  require_relative 'formatters/csv'
  require_relative 'formatters/plain_text'
  require_relative 'formatters/markdown'
  require_relative 'formatters/markdown_table'
  require_relative 'formatters/html'
end
