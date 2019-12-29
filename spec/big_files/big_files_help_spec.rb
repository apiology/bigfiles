# frozen_string_literal: true

require 'spec_helper'
require 'bigfiles'

describe BigFiles::BigFiles do
  let_double :io, :exiter, :file_with_lines, :source_file_globber

  subject(:bigfiles) do
    described_class.new(args,
                        io: io,
                        exiter: exiter,
                        file_with_lines: file_with_lines,
                        source_file_globber: source_file_globber)
  end

  context 'with help argument' do
    subject(:args) { ['-h'] }

    describe '.run' do
      it 'offers help' do
        allow(io).to receive(:puts)
        allow(exiter).to receive(:exit)
        bigfiles.run
        # TODO: Add expectations?
      end
    end
  end
end
