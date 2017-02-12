module Renogen
  module ExtractionStratagies
    module YamlFile

      # Reads change data from files in configured directory
      class Parser
        attr_reader :changelog

        def initialize(options={})
          @changelog = options[:changelog] || ChangeLog::Model.new
          @yaml_file_reader = Reader.new(options['changelog_path'], options)
        end

        # @return [ChangeLog::Model]
        #
        # @raise [Renogen::Exceptions::RuleViolation] when a file does not pass a rule validation
        def parse!
          yaml_file_reader.each_yaml_file do |file, file_path|
            parse_file(file).tap do |results|
              Renogen::Rules::File.validate!(file_path, results)
            end
          end

          changelog
        end

        protected

        attr_reader :yaml_file_reader

        def parse_file(file)
          file.reduce({}) do |hash, file_item|
            group_name, content = file_item

            item = ChangeLog::Item.new(group_name, content)

            changelog.add_change(item)

            hash[group_name] = content

            hash
          end
        end

        def config
          Renogen::Config.instance
        end
      end
    end
  end
end
