# frozen_string_literal: true

module Renogen
  # This is the conductor of the application
  class Generator
    attr_accessor :source, :version, :output_format, :options

    def initialize(version, source, output_format, options = {})
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

      validator.validate!(changelog) if options['validations'].any?
      writer.write!(changelog)
    end

    protected

    def writer
      Renogen::ChangeLog::Writer.new(formatter)
    end

    def extraction_stratagy
      Renogen::ExtractionStratagies.obtain(source, options)
    end

    def formatter
      Renogen::Formatters.obtain(output_format, options)
    end

    def validator
      Renogen::ChangeLog::Validator.new(formatter)
    end
  end
end
