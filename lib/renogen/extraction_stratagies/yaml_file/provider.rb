module Renogen
  module ExtractionStratagies
    module YamlFile

      # Reads change data from files in configured directory
      class Provider < Base
        register :yaml_file
        register :yaml

        def initialize(options={})
          super
          @yaml_parser = Parser.new(options)
        end

        # Parse changes from source
        #
        # @return [ChangeLog::Model]
        def extract
          @yaml_parser.parse!
        end
      end
    end
  end
end
