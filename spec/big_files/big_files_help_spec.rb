# -*- coding: utf-8 -*-
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
