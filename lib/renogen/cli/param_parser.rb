require 'optparse'

module Renogen
  module Cli
    # Extracts options and version from argument list
    class ParamParser
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      # Extracts options and version from argument list
      #
      # @return [Hash] options
      def parse
        args = Hash.new

        opt_parser = OptionParser.new do |opts|
          opts.banner =  "Usage:"
          opts.separator "    renogen [options] VERSION"
          opts.separator "    renogen new TICKET_NAME"
          opts.separator "    renogen init"
          opts.separator ""
          opts.separator "Required:"
          opts.separator "  VERSION      this is the version that is currently being required:"
          opts.separator "  TICKET_NAME  this is the name of the new ticket to be created:"
          opts.separator ""
          opts.separator "Options:"

          opts.on("-fFORMAT", "--format=FORMAT", "Output format to be generated") do |n|
            args['format'] = n
          end

          opts.on("-sSOURCE", "--source=SOURCE", "Type of source that changes will be extracted from") do |n|
            args['source'] = n
          end

          opts.on("-pPATH", "--path=PATH", "Path to changelog files") do |n|
            args['changelog_path'] = n
          end

          opts.on("-lVERSION", "--legacy=VERSION", "Used to collate all changes since") do |n|
            args['legacy_version'] = n
          end

          opts.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end

          opts.on_tail("--version", "Show renogen version") do
            puts Renogen::VERSION
            exit
          end
        end

        opt_parser.parse!(options)

        new_version = options.shift
        if new_version.nil?
          puts "Error: Missing argument"
          puts
          puts opt_parser
          exit 1
        elsif options.count > 0
          puts "Error: Unknown arguments: #{options}"
          puts
          puts opt_parser
          exit 1
        end

        return new_version, args
      end
    end
  end
end
