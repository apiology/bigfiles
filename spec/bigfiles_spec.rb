# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles::BigFiles do
  subject(:io) { double('io') }
  subject(:exiter) { double('exiter') }
  subject(:file_with_lines) { double('file_with_lines') }
  subject(:source_file_finder) { double('source_file_finder') }
  subject(:bigfiles) do
    BigFiles::BigFiles.new(args,
                           io: io,
                           exiter: exiter,
                           file_with_lines: file_with_lines,
                           source_file_finder: source_file_finder)
  end

  context 'With no arguments' do
    subject(:args) { [''] }
    describe '#new' do
      it 'should initialize' do
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
        expect(io).to receive(:puts).with("#{num_lines}: #{filename}")
        file
      end

      it 'should run' do
        file_list = %w(file_1 file_2)
        expect(source_file_finder).to receive(:find).and_return(file_list)
        file_1 = expect_file_processed('file_1', 1)
        file_2 = expect_file_processed('file_2', 2)
        expect(file_1).to receive(:<=>).with(file_2).and_return(1)
        allow(file_2).to receive(:<=>).with(file_1).and_return(-1)
        bigfiles.run
      end
    end
  end

  context 'With help argument' do
    subject(:args) { ['-h'] }
    describe '.run' do
      it 'should offer help' do
        expect(io).to receive(:puts)
        expect(exiter).to receive(:exit)
        bigfiles.run
      end
    end
  end
end
