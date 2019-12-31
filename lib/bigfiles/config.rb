# frozen_string_literal: true

require 'source_finder/option_parser'
require_relative 'quality_config'

module BigFiles
  # Configuration for bigfiles gem
  class Config
    NUM_FILES_DEFAULT = 3

    attr_reader :help, :num_files, :glob, :exclude
    def initialize(source_finder_option_parser: SourceFinder::OptionParser.new,
                   num_files: Config::NUM_FILES_DEFAULT,
                   quality_config: ::BigFiles::QualityConfig.new('bigfiles'),
                   help: false,
                   glob: source_finder_option_parser.default_source_files_glob,
                   exclude: source_finder_option_parser
                     .default_source_files_exclude_glob)
      @num_files = num_files
      @help = help
      @glob = glob
      @exclude = exclude
      @quality_config = quality_config
    end

    def under_limit?(num_lines)
      @quality_config.under_limit?(num_lines)
    end
  end
end
