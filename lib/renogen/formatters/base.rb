module Renogen
  module Formatters
    # Implements a template pattern that forces the implemention of required 
    # methods in sub classes
    class Base
      def initialize(options={})
      end

      # Adds class with identifier to formatters
      #
      # @param identifier [String]
      def self.register(identifier)
        Renogen::Formatters.add(identifier.to_sym, self)
      end

      # Outputs a line or block of text appearing at the top of the change log.
      #
      # @param header [String]
      # @return [NotImplementedError]
      def write_header(header)
        raise NotImplementedError
      end

      # Outputs a line or block as a header for a group.
      #
      # @param group [String]
      # @return [NotImplementedError]
      def write_group(group)
        raise NotImplementedError
      end

      # Outputs a line or block of text appearing after a group.
      #
      # @return [nil]
      def write_group_end
      end

      # Outputs a line or block as the body for a change.
      #
      # @param change [String]
      # @return [NotImplementedError]
      def write_change(change)
        raise NotImplementedError
      end

      # Outputs a line or block of text appearing at the bottom of the change log.
      #
      # @param changelog [ChangeLog]
      # @return [nil]
      def write_footer(changelog)
      end
    end
  end
end
