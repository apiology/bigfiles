# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles do
  subject(:io) { double('io') }
  subject(:exiter) { double('exiter') }
  subject(:file_with_lines) { double('file_with_lines') }
  subject(:source_file_finder) { double('source_file_finder') }
  subject(:bigfiles) do
    BigFiles.new(args,
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
      def expect_file_queried(file, filename:, num_lines:)
        allow(file).to receive(:num_lines).and_return(num_lines)
        allow(file).to receive(:filename).and_return(filename)
      end

      def expect_file_processed(filename)
        file = double("#{filename} file_with_lines")
        expect(file_with_lines).to(receive(:new)).with(filename)
          .and_return(file)
        num_lines = 12
        expect_file_queried(file, filename: filename, num_lines: num_lines)
        expect(io).to receive(:puts).with("#{num_lines}: #{filename}")
      end

      it 'should run' do
        file_list = ['file_1']
        expect(source_file_finder).to receive(:find).and_return(file_list)
        file_list.each do |filename|
          expect_file_processed(filename)
        end
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
