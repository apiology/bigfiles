# Simple tool to find the largest source files in your project.
class BigFiles
  def initialize(args, io: Kernel, exiter: Kernel)
    @args = args
    @io = io
    @exiter = exiter
  end

  def usage
    @io.puts "USAGE: bigfiles [-n <top n files>]\n"
    @exiter.exit 1
  end

  def run
    usage if @args[0] == '-h'
  end
end
