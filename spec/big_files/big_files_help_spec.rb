# frozen_string_literal: true

require 'spec_helper'
require 'bigfiles'

describe BigFiles::BigFiles do
  subject(:bigfiles) do
    described_class.new(args,
                        io: io,
                        exiter: exiter,
                        file_with_lines: file_with_lines,
                        source_file_globber: source_file_globber)
  end

  let(:io) { class_double(Kernel, 'io') }
  let(:exiter) { class_double(Kernel, 'exiter') }
  let(:file_with_lines) do
    class_double(BigFiles::FileWithLines, 'file_with_lines')
  end
  let(:source_file_globber) do
    instance_double(SourceFinder::SourceFileGlobber, 'source_file_globber')
  end

  context 'with help argument' do
    subject(:args) { ['-h'] }

    describe '.run' do
      before do
        allow(io).to receive(:puts)
        allow(exiter).to receive(:exit)
      end

      it 'offers help' do
        bigfiles.run
        expect(exiter).to have_received(:exit)
      end

      it 'exits with correct status' do
        bigfiles.run
        expect(exiter).to have_received(:exit).with(1)
      end
    end
  end
end
