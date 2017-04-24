require 'renogen'
require 'thor'

module Renogen
  class Cli < Thor
    include Thor::Actions

    default_command :generate

    class_option :path,
      desc: 'Path to changelog files',
      type: :string,
      default: Config.instance.changelog_path,
      required: false,
      aliases: %w(-p)

    desc 'generate VERSION', 'Generates the release notes'
    option :format,
      desc: 'Output format to be generated',
      type: :string,
      default: Config.instance.output_format,
      required: false,
      aliases: %w(-f)
    option :source,
      desc: 'Type of source that changes will be extracted from',
      default: Config.instance.input_source,
      required: false,
      aliases: %w(-s)
    option :legacy,
      desc: 'Used to collate all changes since',
      type: :string,
      aliases: %w(-l)
    option :version
    def generate(version = nil)
      opts = options.dup
      
      version_from_opts = opts.delete(:version)
      source = opts.delete(:source)
      format = opts.delete(:format)

      version ||= version_from_opts

      opts['old_version'] = Config.instance.changelog_path

      Renogen::Generator.new(version, source, format, opts).generate!
    rescue Renogen::Exceptions::Base => e
      puts e.message
      exit -1
    end

    desc 'init', 'Creates files used by renogen'
    def init
      # create directory for storing changelog items
      empty_directory options[:path]
      empty_directory File.join(options[:path], 'next')

      # create empty file .gitkeep
      create_file File.join(options[:path], 'next', '.gitkeep'), ''

      # add first changelog item
      create_file File.join(options[:path], 'next', 'added_renogen_gem.yml'), <<-YAML
Summary:
  identifier: renogen
  link: "https://github.com/DDAZZA/renogen"
  summary: Added ReNoGen gem

Detailed: |
  Added ReNoGen gem

  Allows release notes to be generated

Tasks:
  - $ renogen generate vX.Y.Z > release_vX_Y_Z.md
      YAML

      # create config file
      create_file '.renogen', <<-YAML
changelog_path: #{options[:path]}
      YAML
    end

    desc 'new TICKET_NAME', 'Creates a change log entry file'
    option :type,
      desc: 'the type of the change log entry',
      aliases: %w(-t)
    def new(ticket_name)
      create_file(new_file_path_for(ticket_name), template_for(ticket_name))
    end

    desc 'version', 'Show renogen version'
    disable_class_options
    def version
      puts Renogen::VERSION
    end

    private

    def new_inner_file_path_for(ticket_name)
      parts = []

      if options[:type] && !options[:type].empty?
        parts << "#{options[:type].downcase}s"
      end

      parts << "#{ticket_name}.yml"

      File.join(*parts)
    end

    def new_file_path_for(ticket_name)
      File.join(options[:path], 'next', new_inner_file_path_for(ticket_name))
    end

    def template_for(ticket_name)
      file_validator = Renogen::Rules::File.validator_for(new_file_path_for(ticket_name))

      if file_validator
        file_validator.template.to_yaml
      else
        template_for_default_headings.to_yaml
      end
    end

    def template_for_default_headings
      Config.instance.default_headings.each_with_object({}) do |heading, hsh|
        group_validator = Renogen::Rules::Group.validator_for(heading)

        hsh[heading] = if group_validator
          group_validator.template
        else
          Config.instance.supported_keys.each_with_object({}) { |key, inner_hsh| inner_hsh[key] = '' }
        end
      end
    end
  end
end
