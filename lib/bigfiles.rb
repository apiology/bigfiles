require_relative 'source_code_finder'

# Simple tool to find the largest source files in your project.
class BigFiles
  def initialize(args,
                 io: Kernel,
                 exiter: Kernel,
                 file_with_lines: nil,
                 source_file_finder: SourceCodeFinder.new)
    @args = args
    @io = io
    @exiter = exiter
    @file_with_lines = file_with_lines
    @source_file_finder = source_file_finder
  end

  def usage
    @io.puts "USAGE: bigfiles [-n <top n files>]\n"
    @exiter.exit 1
  end

  def find_analyze_and_report_on_files
    file_list = @source_file_finder.find
    files_with_lines = file_list.map do |filename|
      @file_with_lines.new(filename)
    end
    files_with_lines.sort.each do |file|
      @io.puts "#{file.num_lines}: #{file.filename}"
    end
  end

  def run
    if @args[0] == '-h'
      usage
    else
      find_analyze_and_report_on_files
    end
  end
end
