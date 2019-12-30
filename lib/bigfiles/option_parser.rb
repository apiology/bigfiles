# frozen_string_literal: true

require_relative 'config'

module BigFiles
  # Parse options passed to bigfiles command
  class OptionParser
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
              "default #{Config::NUM_FILES_DEFAULT}") do |n|
        options[:num_files] = n
      end
    end

    def add_help_option(opts, options)
      opts.on('-h', '--help', 'This message') { |_| options[:help] = true }
    end

    def parse_options(args)
      options = nil
      @option_parser_class.new do |opts|
        options = setup_options(opts)
        @option_parser = opts
      end.parse!(args)
      Config.new(**options,
                 source_finder_option_parser: @source_finder_option_parser)
    end

    def usage
      @io.puts @option_parser
      @exiter.exit 1
    end
  end
end
