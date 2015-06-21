require_relative 'feature_helper'

describe 'bigfiles' do
  it 'starts up with no arguments' do
    expect(exec_io 'bigfiles -h')
      .to eq("Usage: bigfiles [options]\n" \
             '    -g, --glob glob here             ' \
             'Which files to parse - default is ' \
             "{app,lib,test,spec,feature}/**/*.{rb,swift,cpp,c,java,py}\n" \
             "    -h, --help                       This message\n")
  end

  # three_files one_file two_files some_nonsource_files many_files
  # zero_byte_file
  %w(no_files three_files four_files swift_and_ruby_files
     swift_zorb_and_ruby_files).each do |type|
    it "handles #{type} case" do
      expect(exec_io "cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" bigfiles ' \
                     "--glob '*.{rb,swift,zorb}'")
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end
end
