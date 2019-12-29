# frozen_string_literal: true

module BigFiles
  # Configuration for bigfiles gem
  class Config
    attr_reader :help, :num_files, :glob, :exclude
    def initialize(source_finder_option_parser:,
                   num_files:,
                   help: false,
                   glob: source_finder_option_parser.default_source_files_glob,
                   exclude: source_finder_option_parser.default_source_files_exclude_glob)
      @num_files = num_files
      @help = help
      @glob = glob
      @exclude = exclude
    end
  end
end
