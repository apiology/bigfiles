# frozen_string_literal: true

require 'tmpdir'

# Example use from https://github.com/apiology/pronto-bigfiles

# This spec is here to make sure we don't break backwards
# compatibility with how this is used elsewhere (i.e., establish a
# public interface).

describe BigFiles do
  let(:bigfiles_config) { ::BigFiles::Config.new }

  let(:bigfiles_inspector) { ::BigFiles::Inspector.new }

  let(:bigfiles_results) { bigfiles_inspector.find_and_analyze }

  let(:under_limit) { bigfiles_config.under_limit?(total_lines) }

  let(:total_lines) { bigfiles_results.map(&:num_lines).reduce(:+) }

  let(:sample_filename) { 'file_with_two_lines.rb' }

  let(:file_with_line) do
    bigfiles_results.find { |f| f.filename == sample_filename }
  end

  let(:example_files) do
    {
      sample_filename => "\n\n",
    }
  end

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        system('git init')
        system('git config user.email "you@example.com"')
        system('git config user.name "Fake User"')
        example_files.each do |filename, contents|
          File.write(filename, contents)
        end
        system('git add .')
        system('git commit -m "First commit"')
        example.run
      end
    end
  end

  it 'continues to behave like it did' do
    expect(file_with_line).not_to be_nil
    expect(under_limit).to be(true)
  end
end
