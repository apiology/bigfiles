require 'find'

module BigFiles
  # Finds source code files in the current directory
  class SourceCodeFinder
    def initialize(filefind: Find,
                   globber: Dir)
      @filefind = filefind
      @globber = globber
    end

    def find(glob)
      @globber.glob(glob)
    end
  end
end
