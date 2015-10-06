require 'yaml'

module Renogen
  module ExtractionStratagies
    module YamlFile
      # Reads the relevant yaml files
      class Reader
        attr_accessor :directory_path, :legacy_version

        def initialize(directory_path, options={})
          @legacy_version = options['legacy_version']
          @directory_path = directory_path
          @directory_path ||= './change_log/'
        end

        # Iterates thorugh each change file and yields the contents.
        # 
        # an exception is thrown if the contents are blank
        #
        # @yield [Hash] yaml_file
        def each_yaml_file
          change_directories.each do |file_path|
            content = ::YAML.load_file(file_path)
            raise Exceptions::YamlFileBlank.new(file_path) unless content
            yield content
          end
        end

        private

        # @return [Array]
        def change_directories
          upgrade_versions = legacy_versions.map do |path|
            File.join(path, "*.yml")
          end
          upgrade_versions << File.join(directory_path, 'next', "*.yml")

          Dir.glob(upgrade_versions)
        end

        # @return [Array] 
        def legacy_versions
          return [] unless legacy_version
          legacy_version.gsub!('v','')
          Dir.glob(File.join(directory_path, '*')).select do |dir|
            dir = dir.split('/').last.gsub('v','').gsub('_','.')
            next if dir == 'next'
            Gem::Version.new(dir) > Gem::Version.new(legacy_version)
          end
        end
      end
    end
  end
end
