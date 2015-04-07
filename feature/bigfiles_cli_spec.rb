require_relative 'feature_helper'

describe 'bigfiles' do
  it 'starts up with no arguments' do
    expect(exec_io 'bigfiles -h')
      .to eq("USAGE: bigfiles [-n <top n files>]\n")
  end

  # three_files one_file two_files some_nonsource_files many_files
  # zero_byte_file
  %w(no_files three_files four_files).each do |type|
    it "handles #{type} case" do
      expect(exec_io "cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" bigfiles -n 3')
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end
end
