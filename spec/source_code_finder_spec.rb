# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles::SourceCodeFinder do
  subject(:filefind) { double('filefind') }
  subject(:source_file_finder) do
    BigFiles::SourceCodeFinder.new(filefind: filefind)
  end

  context 'With no files in directory' do
    describe '#find' do
      def it_should_find(filename)
        files = [filename]
        expect(filefind).to receive(:find).with('.').and_yield(filename)
        expect(source_file_finder.find).to eq(files)
      end

      it 'should find a ruby file' do
        it_should_find('foo.rb')
      end

      it 'should find a swift file' do
        it_should_find('bar.swift')
      end

      it 'should not find a dummy file' do
        expect(filefind).to receive(:find).with('.').and_yield('.dummy')
        expect(source_file_finder.find).to eq([])
      end
    end
  end
end
