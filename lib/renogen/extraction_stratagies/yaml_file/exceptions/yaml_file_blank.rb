module Renogen
  module ExtractionStratagies
    module YamlFile
      module Exceptions
        # This is raised when a yaml file change is found but has not contents
        class YamlFileBlank < Renogen::Exceptions::Base
          attr_reader :file_path

          def initialize(file_path)
            @file_path = file_path
            super
          end

          # Friendly error message
          #
          # @return [String]
          def message
            "Error: File contents blank '#{file_path}'"
          end
        end
      end
    end
  end
end

