# frozen_string_literal: true

require 'optparse'
require 'forwardable'

require_relative 'bigfiles/file_with_lines'
require_relative 'bigfiles/option_parser'
require 'source_finder/source_file_globber'
require 'source_finder/option_parser'

# Simple tool to find the largest source files in your project.
module BigFiles
  # Simple tool to find the largest source files in your project.
  class BigFiles
    extend Forwardable

    def initialize(args,
                   io: Kernel,
                   exiter: Kernel,
                   file_with_lines: FileWithLines,
                   source_file_globber: SourceFinder::SourceFileGlobber.new,
                   option_parser_class: ::OptionParser,
                   source_finder_option_parser: SourceFinder::OptionParser.new,
                   bigfiles_option_parser:
                     ::BigFiles::OptionParser
                       .new(option_parser_class: option_parser_class,
                            io: io,
                            exiter: exiter,
                            source_finder_option_parser:
                              source_finder_option_parser),
                   config: bigfiles_option_parser.parse_options(args))
      @io = io
      @file_with_lines = file_with_lines
      @source_file_globber = source_file_globber
      @source_finder_option_parser = source_finder_option_parser
      @bigfiles_option_parser = bigfiles_option_parser
      @config = config
    end

    def find_analyze_and_report_on_files
      @source_file_globber.source_files_glob = @config.glob
      @source_file_globber.source_files_exclude_glob = @config.exclude
      file_list = @source_file_globber.source_files_arr
      files_with_lines = file_list.map do |filename|
        @file_with_lines.new(filename)
      end
      files_with_lines.sort
                      .reverse[0..(@config.num_files - 1)].each do |file|
        @io.puts "#{file.num_lines}: #{file.filename}"
      end
    end

    def run
      if @config.help
        @bigfiles_option_parser.usage
      else
        find_analyze_and_report_on_files
      end
    end
  end
end
