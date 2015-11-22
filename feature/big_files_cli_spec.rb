require_relative 'feature_helper'

describe BigFiles do
  it 'starts up with no arguments' do
    expect(exec_io 'bigfiles -h')
      .to eq("Usage: bigfiles [options]\n" \
             '    -g, --glob glob here             ' \
             'Which files to parse - default is ' \
             '{Rakefile,Dockerfile,{*,.*}.{rb,rake,gemspec,swift,cpp,c,java,' \
             'py,clj,cljs,scala,js,yml,sh,json},{src,app,config,db,lib,test,' \
             'spec,feature}/**/{*,.*}.{rb,rake,gemspec,swift,cpp,c,java,py,' \
             'clj,cljs,scala,js,yml,sh,json}}' \
             "\n" \
             '    -e, --exclude-glob glob here     ' \
             "Files to exclude - default is none\n" \
             "    -h, --help                       This message\n")
  end

  # three_files one_file two_files some_nonsource_files many_files
  # zero_byte_file
  %w(no_files three_files four_files swift_and_ruby_files
     swift_zorb_and_ruby_files
     swift_zorb_and_ruby_files_excluded).each do |type|
    it "handles #{type} case" do
      command = "cd feature/samples/#{type} && " \
                'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" bigfiles ' \
                "--glob '*.{rb,swift,zorb}' " \
                '--exclude-glob ' \
                "'{excluded.rb}'"
      expect(exec_io command)
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end
end
