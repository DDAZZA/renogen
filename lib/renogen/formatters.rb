module Renogen
  # Formatters are used to manipulate how the change is output
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
          raise Renogen::Exceptions::FormatterNotFound.new(format_type)
        end
      end

      # Adds a new formatter class to store
      #
      # @param identifier [Symbol]
      # @param klass [Symbol]
      def add(identifier, klass)
        raise 'name taken' unless formatters[name].nil?
        formatters[identifier]=klass
      end

      private

      def formatters
        @formatters ||= {}
      end
    end
  end

  require 'renogen/formatters/base'
  require 'renogen/formatters/plain_text'
  require 'renogen/formatters/markdown'
  require 'renogen/formatters/html'
end
