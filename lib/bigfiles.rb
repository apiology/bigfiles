# frozen_string_literal: true

require 'optparse'

require_relative 'bigfiles/file_with_lines'
require 'source_finder/source_file_globber'
require 'source_finder/option_parser'

# Simple tool to find the largest source files in your project.
module BigFiles
  # Simple tool to find the largest source files in your project.
  class BigFiles
    NUM_FILES_DEFAULT = 3

    def initialize(args,
                   io: Kernel,
                   exiter: Kernel,
                   file_with_lines: FileWithLines,
                   source_file_globber: SourceFinder::SourceFileGlobber.new,
                   option_parser_class: OptionParser,
                   source_finder_option_parser: SourceFinder::OptionParser.new)
      @io = io
      @exiter = exiter
      @file_with_lines = file_with_lines
      @source_file_globber = source_file_globber
      @option_parser_class = option_parser_class
      @source_finder_option_parser = source_finder_option_parser
      @options = parse_options(args)
    end

    def parse_options(args)
      options = nil
      @option_parser_class.new do |opts|
        options = setup_options(opts)
        @option_parser = opts
      end.parse!(args)
      options
    end

    def glob
      @options[:glob] || @source_finder_option_parser.default_source_files_glob
    end

    def exclude_glob
      @options[:exclude] ||
        @source_finder_option_parser.default_source_files_exclude_glob
    end

    def add_help_option(opts, options)
      opts.on('-h', '--help', 'This message') do |_|
        options[:help] = true
      end
    end

    def add_num_files_option(opts, options)
      opts.on('-n', '--num-files number-here',
              Integer,
              'Top number of files to show--' \
              "default #{NUM_FILES_DEFAULT}") do |n|
        options[:num_files] = n
      end
    end

    def setup_options(opts)
      options = {}
      options[:num_files] = NUM_FILES_DEFAULT # default
      opts.banner = 'Usage: bigfiles [options]'
      @source_finder_option_parser.add_options(opts, options)
      add_help_option(opts, options)
      add_num_files_option(opts, options)
      options
    end

    def usage
      @io.puts @option_parser
      @exiter.exit 1
    end

    def find_analyze_and_report_on_files
      @source_file_globber.source_files_glob = glob
      @source_file_globber.source_files_exclude_glob = exclude_glob
      file_list = @source_file_globber.source_files_arr
      files_with_lines = file_list.map do |filename|
        @file_with_lines.new(filename)
      end
      files_with_lines.sort
                      .reverse[0..(@options[:num_files] - 1)].each do |file|
        @io.puts "#{file.num_lines}: #{file.filename}"
      end
    end

    def run
      if @options[:help]
        usage
      else
        find_analyze_and_report_on_files
      end
    end
  end
end
