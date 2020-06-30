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

      # Generate a header for a given changelog
      #
      # @param changelog [Renogen::ChangeLog::Model]
      #
      # return [String]
      def header(changelog)
        "#{changelog.version} (#{changelog.date})"
      end

      # Outputs a line or block of text appearing at the top of the change log.
      #
      # @abstract
      #
      # @param header [String]
      # @raise NotImplementedError
      def write_header(header)
        raise NotImplementedError
      end

      # Outputs a line or block listing all group headings found in the change log.
      #
      # @abstract
      #
      # @param changelog [Renogen::ChangeLog::Model]
      # @raise NotImplementedError
      def write_headings(changelog)
        raise NotImplementedError
      end

      # Outputs a line or block as a header for a group.
      #
      # @abstract
      #
      # @param group [String]
      # @raise NotImplementedError
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
      # @abstract
      #
      # @param change [String]
      # @raise NotImplementedError
      def write_change(change)
        raise NotImplementedError
      end

      # Outputs the hash contents of a full YAML release notes file
      #
      # @abstract
      #
      # @param file [Hash]
      # @raise NotImplementedError
      def write_file(file)
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
