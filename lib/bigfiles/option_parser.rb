# frozen_string_literal: true

module BigFiles
  # Configuration for bigfiles gem
  class Config
    attr_reader :help, :num_files, :glob, :exclude
    def initialize(num_files:,
                   help: false,
                   glob: nil,
                   exclude: nil)
      @num_files = num_files
      @help = help
      @glob = glob
      @exclude = exclude
    end
  end
  # Parse options passed to bigfiles command
  class OptionParser
    NUM_FILES_DEFAULT = 3

    def initialize(option_parser_class: ::OptionParser,
                   io: Kernel,
                   exiter: Kernel,
                   source_finder_option_parser:)
      @option_parser_class = option_parser_class
      @io = io
      @exiter = exiter
      @source_finder_option_parser = source_finder_option_parser
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

    def add_num_files_option(opts, options)
      opts.on('-n', '--num-files number-here',
              Integer,
              "Top number of files to show--" \
              "default #{NUM_FILES_DEFAULT}") do |n|
        options[:num_files] = n
      end
    end

    def add_help_option(opts, options)
      opts.on('-h', '--help', 'This message') do |_|
        options[:help] = true
      end
    end

    def parse_options(args)
      options = nil
      @option_parser_class.new do |opts|
        options = setup_options(opts)
        @option_parser = opts
      end.parse!(args)
      Config.new(**options)
    end

    def usage
      @io.puts @option_parser
      @exiter.exit 1
    end
  end
end
