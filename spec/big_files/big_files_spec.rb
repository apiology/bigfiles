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
    context "With glob of #{glob}" do
      let(:exclude_glob) { config[:exclude] }
      let(:num_files) { config[:num_files] }

      subject(:args) do
        args = []
        args += ['--glob', glob] unless glob.nil?
        args += ['--exclude', exclude_glob] unless exclude_glob.nil?
        args += ['--num-files', num_files] unless num_files.nil?
        args
      end

      describe '.run' do
        def allow_file_queried(file, filename: raise, num_lines: raise)
          allow(file).to receive(:num_lines).and_return(num_lines)
          allow(file).to receive(:filename).and_return(filename)
        end

        def expect_file_processed(filename, num_lines)
          file = instance_double(BigFiles::FileWithLines,
                                 "#{filename} file_with_lines")
          allow(file_with_lines).to(receive(:new)).with(filename)
                                .and_return(file)
          allow_file_queried(file, filename: filename, num_lines: num_lines)
          file
        end

        def allow_file_output(filename, num_lines)
          allow(io).to receive(:puts).with("#{num_lines}: #{filename}")
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
          file_list = %w[file_1 file_2 file_3 file_4]
          allow_globs_assigned(glob, exclude_glob)
          allow(source_file_globber).to(receive(:source_files_arr))
                                    .and_return(file_list)
        end

        # TODO: Should this be allow?
        let(:file_1) { expect_file_processed('file_1', 4) }
        let(:file_2) { expect_file_processed('file_2', 3) }
        let(:file_3) { expect_file_processed('file_3', 2) }
        let(:file_4) { expect_file_processed('file_4', 1) }

        def allow_file_1_sorted
          allow(file_1).to receive(:<=>).with(file_2).and_return(1)
          allow(file_1).to receive(:<=>).with(file_3).and_return(1)
          allow(file_1).to receive(:<=>).with(file_4).and_return(1)
        end

        def allow_file_2_sorted
          allow(file_2).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_2).to receive(:<=>).with(file_3).and_return(1)
          allow(file_2).to receive(:<=>).with(file_4).and_return(1)
        end

        def allow_file_3_sorted
          allow(file_3).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_3).to receive(:<=>).with(file_2).and_return(-1)
          allow(file_3).to receive(:<=>).with(file_4).and_return(1)
        end

        def allow_file_4_sorted
          allow(file_4).to receive(:<=>).with(file_1).and_return(-1)
          allow(file_4).to receive(:<=>).with(file_2).and_return(-1)
          allow(file_4).to receive(:<=>).with(file_3).and_return(-1)
        end

        def allow_file_comparisons
          allow_file_1_sorted
          allow_file_2_sorted
          allow_file_3_sorted
          allow_file_4_sorted
        end

        def allow_files_output
          allow_file_output('file_1', 4)
          allow_file_output('file_2', 3)
          allow_file_output('file_3', 2)
          allow_file_output('file_4', 1) if num_files && num_files.to_i >= 4
        end

        it 'runs' do
          allow_source_globber_used(glob, exclude_glob)
          allow_file_comparisons
          allow_files_output

          bigfiles.run
          # TODO: Shouldn't we have expectations here?
        end
      end
    end
  end
end
