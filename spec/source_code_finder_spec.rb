# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe SourceCodeFinder do
  subject(:filefind) { double('filefind') }
  subject(:source_file_finder) { SourceCodeFinder.new(filefind: filefind) }

  context 'With no files in directory' do
    describe '#find' do
      it 'should find a ruby file' do
        files = ['foo.rb']
        expect(filefind).to receive(:find).with('.').and_yield('foo.rb')
        expect(source_file_finder.find).to eq(files)
      end

      it 'should not find a dummy file' do
        expect(filefind).to receive(:find).with('.').and_yield('.dummy')
        expect(source_file_finder.find).to eq([])
      end
    end
  end
end
