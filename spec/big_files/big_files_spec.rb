# frozen_string_literal: true

require 'spec_helper'
require 'bigfiles'
require 'bigfiles/file_with_lines'

describe BigFiles::BigFiles do
  # Until this spec is decoupled from source_finder changes, make sure
  # that RSpec shows the actual difference:
  #
  # https://github.com/rspec/rspec-core/issues/2535
  RSpec::Support::ObjectFormatter
    .default_instance.max_formatted_output_length = 999

  subject(:bigfiles) do
    described_class.new(args,
                        io_class: io_class,
                        exiter: exiter,
                        file_with_lines: file_with_lines,
                        source_file_globber: source_file_globber)
  end

  let(:io_class) { class_double(Kernel, 'io_class') }
  let(:exiter) { class_double(Kernel, 'exiter') }
  let(:file_with_lines) do
    class_double(BigFiles::FileWithLines, 'file_with_lines')
  end
  let(:source_file_globber) do
    instance_double(SourceFinder::SourceFileGlobber, 'source_file_globber')
  end

  [{ glob: nil, exclude: nil },
   { glob: '*/*.{rb,swift}', exclude: '*/foo.rb' },
   { glob: '*/*.{rb,swift}', exclude: '*/foo.rb',
     num_files: '6' }].each do |config|
    glob = config[:glob]
    context "With glob of #{glob}" do
      subject(:args) do
        args = []
        args += ['--glob', glob] unless glob.nil?
        args += ['--exclude', exclude_glob] unless exclude_glob.nil?
        args += ['--num-files', num_files] unless num_files.nil?
        args
      end

      let(:exclude_glob) { config[:exclude] }
      let(:num_files) { config[:num_files] }

      describe '.run' do
        def allow_file_queried(file, filename: raise, num_lines: raise)
          allow(file).to receive(:num_lines).and_return(num_lines)
          allow(file).to receive(:filename).and_return(filename)
        end

        def allow_file_processed(filename, num_lines)
          file = instance_double(BigFiles::FileWithLines,
                                 "#{filename} file_with_lines")
          allow(file_with_lines).to(receive(:new)).with(filename)
            .and_return(file)
          allow_file_queried(file, filename: filename, num_lines: num_lines)
          file
        end

        def allow_file_output(filename, num_lines)
          allow(io_class).to receive(:puts).with("#{num_lines}: #{filename}")
        end

        def expect_file_output(filename, num_lines)
          expect(io_class).to have_received(:puts).with("#{num_lines}: #{filename}")
            .once
        end

        def default_glob
          '{Dockerfile,Rakefile,{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,' \
          'java,js,json,py,rake,rb,scala,sh,swift,yml},{app,config,db,' \
          'feature,lib,spec,src,test,tests,vars,www}/**/{*,.*}.{c,clj,' \
          'cljs,cpp,gemspec,groovy,html,java,js,json,py,rake,rb,scala,' \
          'sh,swift,yml}}'
        end

        def allow_globs_assigned(glob, exclude_glob)
          actual_glob = glob || default_glob
          actual_exclude_glob = exclude_glob || '**/vendor/**'
          allow(source_file_globber).to(receive(:source_files_glob=))
            .with(actual_glob)
          allow(source_file_globber).to(receive(:source_files_exclude_glob=))
            .with(actual_exclude_glob)
        end

        def allow_source_globber_used(glob, exclude_glob)
          file_list = %w[file_one file_two file_three file_four]
          allow_globs_assigned(glob, exclude_glob)
          allow(source_file_globber).to(receive(:source_files_arr))
            .and_return(file_list)
        end

        let(:file_one) { allow_file_processed('file_one', 4) }
        let(:file_two) { allow_file_processed('file_two', 3) }
        let(:file_three) { allow_file_processed('file_three', 2) }
        let(:file_four) { allow_file_processed('file_four', 1) }

        def sorts_as_smaller_than(file_a, file_b)
          allow(file_a).to receive(:<=>).with(file_b).and_return(-1)
        end

        def sorts_as_larger_than(file_a, file_b)
          allow(file_a).to receive(:<=>).with(file_b).and_return(1)
        end

        def allow_file_one_sorted
          sorts_as_larger_than(file_one, file_two)
          sorts_as_larger_than(file_one, file_three)
          sorts_as_larger_than(file_one, file_four)
        end

        def allow_file_two_sorted
          sorts_as_smaller_than(file_two, file_one)
          sorts_as_larger_than(file_two, file_three)
          sorts_as_larger_than(file_two, file_four)
        end

        def allow_file_three_sorted
          sorts_as_smaller_than(file_three, file_one)
          sorts_as_smaller_than(file_three, file_two)
          sorts_as_larger_than(file_three, file_four)
        end

        def allow_file_four_sorted
          sorts_as_smaller_than(file_four, file_one)
          sorts_as_smaller_than(file_four, file_two)
          sorts_as_smaller_than(file_four, file_three)
        end

        def allow_file_comparisons
          allow_file_one_sorted
          allow_file_two_sorted
          allow_file_three_sorted
          allow_file_four_sorted
        end

        def allow_files_output
          allow_file_output('file_one', 4)
          allow_file_output('file_two', 3)
          allow_file_output('file_three', 2)
          allow_file_output('file_four', 1) if num_files && num_files.to_i >= 4
        end

        def expect_files_output
          expect_file_output('file_one', 4)
          expect_file_output('file_two', 3)
          expect_file_output('file_three', 2)
          expect_file_output('file_four', 1) if num_files && num_files.to_i >= 4
        end

        it 'runs' do
          allow_source_globber_used(glob, exclude_glob)
          allow_file_comparisons
          allow_files_output
          bigfiles.run
          expect_files_output
        end
      end
    end
  end
end
