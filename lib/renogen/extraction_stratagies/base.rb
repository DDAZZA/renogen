module Renogen
  module ExtractionStratagies
    # Template for all extraction stratagies
    class Base

      # Adds class with identifier to extraction stratagies
      #
      # @param identifier [String]
      def self.register(identifier)
        Renogen::ExtractionStratagies.add(identifier.to_sym, self)
      end

      def initialize(options={})
        @changelog ||= ChangeLog::Model.new
      end

      # Parse changes from source
      #
      # @return [NotImplementedError]
      def extract
        raise NotImplementedError
      end

      protected

      attr_reader :changelog
    end
  end
end
