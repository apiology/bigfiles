require 'find'

# Finds source code files in the current directory
class SourceCodeFinder
  def initialize(filefind: Find)
    @filefind = filefind
  end

  def find
    files = []
    @filefind.find('.') do |path|
      files << path if path =~ /.*\.rb$/ || path =~ /.*\.swift$/
    end
    files.map do |filename|
      filename.sub(/^.\//, '')
    end
  end
end
