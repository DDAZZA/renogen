module Renogen
  # This is the conductor of the application
  class Generator
    attr_accessor :source, :version, :output_format, :options

    def initialize(version, source, output_format, options={})
      @version = version
      @source = source
      @output_format = output_format
      @options = options
    end

    # Create the change log
    def generate!
      changelog = extraction_stratagy.extract
      changelog.version = version
      changelog.date = options['release_date']

      writer.write!(changelog)
    end

    protected

    def writer
      Renogen::Writers.obtain(output_format, formatter)
    end

    def extraction_stratagy
      Renogen::ExtractionStratagies.obtain(source, options)
    end

    def formatter
      Renogen::Formatters.obtain(output_format, options)
    end
  end
end
