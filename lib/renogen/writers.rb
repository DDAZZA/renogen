# frozen_string_literal: true

module Renogen
  # Writers allow customisation of the structure and layout of formatted output
  module Writers
    class << self
      # Retrieves a writer from a given key, and initialises with given formatter
      #
      # @param format_type [String] identifier for writer
      # @param formatter [Renogen::Formatters::Base] formatter to initialise writer with
      # @return [Writers::Base]
      def obtain(format_type, formatter)
        writer = writers[format_type.to_sym]
        return writer.new(formatter) if writer

        writers[:default].new(formatter)
      end

      # Adds a new writer class to store
      #
      # @param identifier [Symbol]
      # @param klass [Symbol]
      def add(identifiers, klass)
        identifiers.each do |identifier|
          writers[identifier] = klass
        end
      end

      private

      def writers
        @writers ||= {}
      end
    end
  end

  require_relative 'writers/base'
  require_relative 'writers/csv'
  require_relative 'writers/html'
  require_relative 'writers/markdown'
  require_relative 'writers/plain_text'
end
