module Renogen
  module ExtractionStratagies
    module YamlFile
      # Reads change data from files in configured directory
      class Parser
        attr_reader :changelog

        def initialize(options = {})
          @changelog = options[:changelog] || ChangeLog::Model.new
          @yaml_file_reader = Reader.new(options['changelog_path'], options)
        end

        # @return [ChangeLog::Model]
        def parse!
          yaml_file_reader.each_yaml_file do |file|
            parse_file(file)
          end
          changelog
        end

        protected

        attr_reader :yaml_file_reader

        def parse_file(file)
          file.each do |group_name, content|
            changelog.add_change(ChangeLog::Item.new(group_name, content))
          end
        end

        def config
          Renogen::Config.instance
        end
      end
    end
  end
end
