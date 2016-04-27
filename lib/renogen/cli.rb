require 'renogen'

module Renogen
  # Command line interface helpers
  module Cli
    require 'renogen/cli/param_parser'

    # Execute the program via command line
    # Renogen exceptions will be rescued and printed
    # @param args [Array]
    def self.run(args)
      return init if args.first == 'init'
      return new_ticket(args[1]) if args.first == 'new'

      param_parser = ParamParser.new(args)
      version, options = param_parser.parse
      config_instance = Config.instance

      format = options['format'] || config_instance.output_format
      source = options['source'] || config_instance.input_source
      options['changelog_path'] ||= config_instance.changelog_path
      options['old_version'] ||= config_instance.changelog_path

      begin
        generator = Renogen::Generator.new(version, source, format, options)
        generator.generate!
      rescue Renogen::Exceptions::Base => e
        puts e.message
        exit -1
      end
    end

    # Initialize the current working directory with an example change
    def self.init
      # TODO: Refactor to use Config.instance.changelog_path
      Dir.mkdir('./change_log')
      puts "Created './change_log/'"

      Dir.mkdir('./change_log/next')
      puts "Created './change_log/next/'"

      File.open('./change_log/next/added_renogen_gem.yml', 'w') do |f|
        f.write("Summary:\n")
        f.write("  identifier: renogen\n")
        f.write("  link: https://github.com/DDAZZA/renogen\n")
        f.write("  summary: Added ReNoGen gem\n")
        f.write("\n")
        f.write("Detailed: |\n")
        f.write("  Added ReNoGen gem\n")
        f.write("\n")
        f.write("  Allows release notes to be generated\n")
        f.write("\n")
        f.write("Tasks:\n")
        f.write("  - $ renogen vX.Y.Z > release_vX_Y_Z.md\n")
      end

      puts "Created './change_log/next/added_renogen_gem.yml'"

      File.open('.renogen', 'w') do |f|
        f.write("changelog_path: './change_log/'\n")
      end
      puts "Created '.renogen'"
    end

    # Creates a new template file
    #
    # @param ticket_name [String]
    def self.new_ticket(ticket_name)
      file_path = File.join(Config.instance.changelog_path, 'next', "#{ticket_name}.yml")
      File.open(file_path, 'w') do |f|
        Config.instance.default_headings.each do |h|
          f.write("#{h}:\n")
        end
      end
      puts "Created '#{file_path}'"
    end
  end
end
