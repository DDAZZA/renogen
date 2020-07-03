module Renogen
  module ExtractionStratagies
    # module for extracting changes from YAML files
    module YamlFile
      require_relative 'yaml_file/reader'
      require_relative 'yaml_file/parser'
      require_relative 'yaml_file/provider'
    end
  end
end
