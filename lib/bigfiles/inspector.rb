# frozen_string_literal: true

# Simple tool to find the largest source files in your project.
module BigFiles
  # Investigate a project and generate a report on the n biggest files
  class Inspector
    def initialize(config:,
                   source_file_globber:,
                   file_with_lines:,
                   io:)
      @config = config
      @source_file_globber = source_file_globber
      @file_with_lines = file_with_lines
      @io = io
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
  end
end