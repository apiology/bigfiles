# frozen_string_literal: true

require 'optparse'

require 'bigfiles/file_with_lines'
require 'bigfiles/option_parser'
require 'bigfiles/inspector'
require 'bigfiles/version'
require 'source_finder/source_file_globber'
require 'source_finder/option_parser'

# Simple tool to find the largest source files in your project.
module BigFiles
  # Simple tool to find the largest source files in your project.
  class BigFiles
    def initialize(args,
                   io_class: Kernel,
                   exiter: Kernel,
                   file_with_lines: FileWithLines,
                   source_file_globber: SourceFinder::SourceFileGlobber.new,
                   inspector_class: Inspector,
                   option_parser_class: ::OptionParser,
                   source_finder_option_parser: SourceFinder::OptionParser.new,
                   bigfiles_option_parser:
                     ::BigFiles::OptionParser
                       .new(option_parser_class: option_parser_class,
                            io_class: io_class,
                            exiter: exiter,
                            source_finder_option_parser:
                              source_finder_option_parser),
                   config: bigfiles_option_parser.parse_options(args))
      @bigfiles_option_parser = bigfiles_option_parser
      @config = config
      @inspector = inspector_class.new(source_file_globber: source_file_globber,
                                       config: config,
                                       file_with_lines: file_with_lines,
                                       io_class: io_class)
    end

    def run
      if @config.help
        @bigfiles_option_parser.usage
      else
        @inspector.find_analyze_and_report_on_files
      end
    end
  end
end
