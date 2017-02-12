require 'singleton'
require 'yaml'

module Renogen
  # Stores configuratin values to be used by the libary
  class Config
    include Singleton
    attr_accessor :single_line_format, :input_source, :output_format, :supported_keys, :changelog_path,
                  :default_headings, :file_rules, :group_rules

    def initialize
      config_file = load_yaml_config
      self.single_line_format = config_file['single_line_format'] || 'summary (see link)'.freeze
      self.supported_keys = config_file['supported_keys'] || ['identifier', 'link', 'summary'].freeze
      self.input_source = config_file['input_source'] || 'yaml'.freeze
      self.output_format = config_file['output_format'] || 'markdown'.freeze
      self.changelog_path = config_file['changelog_path'] || './change_log'.freeze
      self.default_headings = config_file['default_headings'] || %w(Summary Detailed Tasks).freeze

      parse_file_rules(config_file['file_rules'])
      parse_group_rules(config_file['group_rules'])
    end

    # Renogen configuration extension
    # a block can be provided to programatily setup configuration values
    def self.configure
      yield instance
    end

    # @param group_name [String]
    #
    # @return [Array<String>] list of supported key names for the given group name
    def supported_keys_for(group_name)
      group_validator = Renogen::Rules::Group.validator_for(group_name)

      if group_validator
        group_validator.supported_keys
      else
        supported_keys
      end
    end

    private

    def load_yaml_config(config_file_path='.renogen')
      begin
        YAML.load_file(config_file_path)
      rescue => e
        $stderr.puts "Warning: Couldn't parse #{config_file_path}. #{e.message}"

        {}
      end
    end

    def parse_file_rules(config_hash)
      @file_rules = if config_hash
                      Hash[config_hash.map { |pattern, config| [pattern, Renogen::Rules::File.new(pattern, config)] }]
                    else
                      {}
                    end
    end

    def parse_group_rules(config_hash)
      @group_rules = if config_hash
                       Hash[
                         config_hash.map do |group_name, config|
                           [group_name, Renogen::Rules::Validators.obtain(group_name, config)]
                         end
                       ]
                     else
                       {}
                     end
    end
  end
end
