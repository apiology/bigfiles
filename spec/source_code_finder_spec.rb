# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe BigFiles::SourceCodeFinder do
  subject(:filefind) { double('filefind') }
  subject(:globber) { double('globber') }
  subject(:source_file_finder) do
    BigFiles::SourceCodeFinder.new(filefind: filefind,
                                   globber: globber)
  end

  context 'With no files in directory' do
    let_double :glob

    describe '#find' do
      def it_should_find(filename)
        files = [filename]
        expect(globber).to receive(:glob).with(glob).and_return(files)
        expect(source_file_finder.find(glob)).to eq(files)
      end

      it 'should find a ruby file' do
        it_should_find('foo.rb')
      end

      it 'should find a swift file' do
        it_should_find('bar.swift')
      end

      it 'should not find a dummy file' do
        expect(globber).to receive(:glob).with(glob).and_return([])
        expect(source_file_finder.find(glob)).to eq([])
      end
    end
  end
end
