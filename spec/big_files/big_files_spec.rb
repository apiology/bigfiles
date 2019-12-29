# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles::BigFiles do
  #
  # Until this spec is decoupled from source_finder changes, make sure
  # that RSpec shows the actual difference:
  #
  # https://github.com/rspec/rspec-core/issues/2535
  #
  RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 999

  let_double :io, :exiter, :file_with_lines, :source_file_globber

  subject(:bigfiles) do
    described_class.new(args,
                        io: io,
                        exiter: exiter,
                        file_with_lines: file_with_lines,
                        source_file_globber: source_file_globber)
  end

  [{ glob: nil, exclude: nil },
   { glob: '*/*.{rb,swift}', exclude: '*/foo.rb' },
   { glob: '*/*.{rb,swift}', exclude: '*/foo.rb',
     num_files: '6' }].each do |config|
    glob = config[:glob]
    exclude_glob = config[:exclude]
    num_files = config[:num_files]
    context "With glob of #{glob}" do
      subject(:args) do
        args = []
        args += ['--glob', glob] unless glob.nil?
        args += ['--exclude', exclude_glob] unless exclude_glob.nil?
        args += ['--num-files', num_files] unless num_files.nil?
        args
      end

      describe '#new' do
        it 'initializes' do
          subject
        end
      end

      describe '.run' do
        def expect_file_queried(file, filename: fail, num_lines: fail)
          allow(file).to receive(:num_lines).and_return(num_lines)
          allow(file).to receive(:filename).and_return(filename)
        end

        def expect_file_processed(filename, num_lines)
          file = double("#{filename} file_with_lines")
          expect(file_with_lines).to(receive(:new)).with(filename)
            .and_return(file)
          expect_file_queried(file, filename: filename, num_lines: num_lines)
          file
        end

        def expect_file_output(filename, num_lines)
          expect(io).to receive(:puts).with("#{num_lines}: #{filename}")
        end

        def default_glob
          '{Dockerfile,Rakefile,{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,' \
          'java,js,json,py,rake,rb,scala,sh,swift,yml},{app,config,db,' \
          'feature,lib,spec,src,test,tests,vars,www}/**/{*,.*}.{c,clj,' \
          'cljs,cpp,gemspec,groovy,html,java,js,json,py,rake,rb,scala,' \
          'sh,swift,yml}}'
        end

        def expect_globs_assigned(glob, exclude_glob)
          actual_glob = glob || default_glob
          actual_exclude_glob = exclude_glob || '**/vendor/**'
          expect(source_file_globber).to(receive(:source_files_glob=))
            .with(actual_glob)
          expect(source_file_globber).to(receive(:source_files_exclude_glob=))
            .with(actual_exclude_glob)
        end

        def expect_source_globber_used(glob, exclude_glob)
          file_list = %w(file_1 file_2 file_3 file_4)
          expect_globs_assigned(glob, exclude_glob)
          expect(source_file_globber).to(receive(:source_files_arr))
            .and_return(file_list)
        end

        it 'runs' do
          expect_source_globber_used(glob, exclude_glob)
          file_1 = expect_file_processed('file_1', 4)
          file_2 = expect_file_processed('file_2', 3)
          file_3 = expect_file_processed('file_3', 2)
          file_4 = expect_file_processed('file_4', 1)

          allow(file_1).to receive(:<=>).with(file_2).and_return(1)
          allow(file_1).to receive(:<=>).with(file_3).and_return(1)
          allow(file_1).to receive(:<=>).with(file_4).and_return(1)

          allow(file_2).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_2).to receive(:<=>).with(file_3).and_return(1)
          allow(file_2).to receive(:<=>).with(file_4).and_return(1)

          allow(file_3).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_3).to receive(:<=>).with(file_2).and_return(-1)
          allow(file_3).to receive(:<=>).with(file_4).and_return(1)

          allow(file_4).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_4).to receive(:<=>).with(file_2).and_return(-1)
          allow(file_4).to receive(:<=>).with(file_3).and_return(-1)

          expect_file_output('file_1', 4)
          expect_file_output('file_2', 3)
          expect_file_output('file_3', 2)
          expect_file_output('file_4', 1) if num_files && num_files.to_i >= 4

          bigfiles.run
        end
      end
    end
  end

  context 'With help argument' do
    subject(:args) { ['-h'] }
    describe '.run' do
      it 'offers help' do
        expect(io).to receive(:puts)
        expect(exiter).to receive(:exit)
        bigfiles.run
      end
    end
  end
end
