# frozen_string_literal: true

require_relative 'feature_helper'

describe BigFiles do
  let(:default_glob) do
    '{Dockerfile,Rakefile,{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,' \
      'java,js,json,py,rake,rb,scala,sh,swift,yml},{app,config,db,feature,' \
      'lib,spec,src,test,tests,vars,www}/**/{*,.*}.{c,clj,cljs,cpp,gemspec,' \
      'groovy,html,java,js,json,py,rake,rb,scala,sh,swift,yml}}'
  end

  let(:usage) do
    "Usage: bigfiles [options]\n" \
      "    -g, --glob glob here             " \
      "Which files to parse - default is #{default_glob}" \
      "\n" \
      "    -e, --exclude-glob glob here     " \
      "Files to exclude - default is none\n" \
      "    -h, --help                       This message\n" \
      "    -n, --num-files number-here      " \
      "Top number of files to show--default 3\n"
  end

  it 'starts up with no arguments' do
    expect(exec_io('bigfiles -h')).to eq(usage)
  end

  # three_files one_file two_files some_nonsource_files many_files
  # zero_byte_file
  %w[no_files three_files four_files swift_and_ruby_files
     swift_zorb_and_ruby_files
     swift_zorb_and_ruby_files_excluded].each do |type|
    context "with #{type}" do
      let(:command) do
        "cd feature/samples/#{type} && " \
          "RUBYLIB=`pwd`/../../lib:\"\$RUBYLIB\" bigfiles " \
          "--glob '*.{rb,swift,zorb}' " \
          "--exclude-glob " \
          "'{excluded.rb}'"
      end

      it "handles #{type} case" do
        expect(exec_io(command))
          .to eq(File.read("feature/expected/#{type}_results.txt"))
      end
    end
  end
end
