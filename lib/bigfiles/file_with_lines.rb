# frozen_string_literal: true

module BigFiles
  # Encapsulates a file which has a certain number of lines
  class FileWithLines
    attr_reader :filename

    def initialize(filename, file_opener: File)
      @filename = filename
      @file_opener = file_opener
    end

    def <=>(other)
      num_lines <=> other.num_lines
    end

    def num_lines
      num_lines = 0
      @file_opener.open(filename, 'r') do |file|
        file.each_line do |_line|
          num_lines += 1
        end
      end
      num_lines
    end
  end
end
