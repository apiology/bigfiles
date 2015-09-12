require 'optparse'

require_relative 'bigfiles/source_code_finder'
require_relative 'bigfiles/file_with_lines'

# XXX: Take out source_file_globber.rb from quality into its own gem
# and start building on that.

# Simple tool to find the largest source files in your project.
module BigFiles
  # Simple tool to find the largest source files in your project.
  class BigFiles
    def initialize(args,
                   io: Kernel,
                   exiter: Kernel,
                   file_with_lines: FileWithLines,
                   source_file_finder: SourceCodeFinder.new,
                   option_parser_class: OptionParser)
      @io = io
      @exiter = exiter
      @file_with_lines = file_with_lines
      @source_file_finder = source_file_finder
      @option_parser_class = option_parser_class
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

    DEFAULT_GLOB =
      '{app,lib,test,spec,feature}/**/*.{rb,swift,cpp,c,java,py}'

    def glob
      @options[:glob] || DEFAULT_GLOB
    end

    def exclude_glob
      @options[:exclude] || ''
    end

    def add_glob_option(opts, options)
      opts.on('-g glob here', '--glob',
              "Which files to parse - default is #{DEFAULT_GLOB}") do |v|
        options[:glob] = v
      end
    end

    def add_exclude_glob_option(opts, options)
      opts.on('-e glob here', '--exclude-glob',
              'Files to exclude - default is none') do |v|
        options[:exclude] = v
      end
    end

    def add_help_option(opts, options)
      opts.on('-h', '--help', 'This message') do |_|
        options[:help] = true
      end
    end

    def setup_options(opts)
      options = {}
      opts.banner = 'Usage: bigfiles [options]'
      add_glob_option(opts, options)
      add_exclude_glob_option(opts, options)
      add_help_option(opts, options)
      options
    end

    def usage
      @io.puts @option_parser
      @exiter.exit 1
    end

    def find_analyze_and_report_on_files
      file_list = @source_file_finder.find(glob, exclude_glob)
      files_with_lines = file_list.map do |filename|
        @file_with_lines.new(filename)
      end
      files_with_lines.sort.reverse[0..2].each do |file|
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
