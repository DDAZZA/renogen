module Renogen
  # Methods for extracting release notes
  module ExtractionStratagies
    class << self
      # Retrieves a stratagy from a given key
      #
      # @param stratagy_type [String] identifier for stratagy
      # @param options [Hash] any options required for stratagy
      # @return [ExtractionStratagies::Base]
      def obtain(stratagy_type, options = {})
        stratagy = stratagies[stratagy_type.to_s]
        if stratagy
          stratagy.new(options)
        else
          raise Renogen::Exceptions::StratagyNotFound.new(stratagy_type)
        end
      end

      # Adds a new stratagy class to store
      #
      # @param identifier [Symbol]
      # @param klass [Symbol]
      def add(identifier, klass)
        # raise 'name taken' unless stratagies[name].nil?
        stratagies[identifier.to_s] = klass
      end

      private

      def stratagies
        @stratagies ||= {}
      end
    end

    require_relative 'extraction_stratagies/base'
    require_relative 'extraction_stratagies/yaml_file'
    # require_relative 'extraction_stratagies/github'
    # require_relative 'extraction_stratagies/gitlog'
  end
end
