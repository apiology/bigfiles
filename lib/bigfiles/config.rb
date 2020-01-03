# frozen_string_literal: true

require 'source_finder/option_parser'
require 'quality/threshold'

module BigFiles
  # Configuration for bigfiles gem
  class Config
    NUM_FILES_DEFAULT = 3

    attr_reader :help, :num_files, :glob, :exclude, :minimum_high_water_mark
    def initialize(source_finder_option_parser: SourceFinder::OptionParser.new,
                   num_files: Config::NUM_FILES_DEFAULT,
                   quality_threshold: ::Quality::Threshold.new('bigfiles'),
                   minimum_high_water_mark: 300,
                   help: false,
                   glob: source_finder_option_parser.default_source_files_glob,
                   exclude: source_finder_option_parser
                     .default_source_files_exclude_glob)
      @num_files = num_files
      @help = help
      @glob = glob
      @exclude = exclude
      @quality_threshold = quality_threshold
      @minimum_high_water_mark = minimum_high_water_mark
    end

    def high_water_mark
      @quality_threshold.threshold || @minimum_high_water_mark
    end

    def under_limit?(num_lines)
      num_lines <= high_water_mark
    end
  end
end
