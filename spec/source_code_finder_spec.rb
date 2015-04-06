# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bigfiles'

describe SourceCodeFinder do
  subject(:source_file_finder) { SourceCodeFinder.new }

  context 'With no files in directory' do
    describe '#find' do
      it 'should find no files' do
        files = []
        expect(source_file_finder.find).to eq(files)
      end
    end
  end
end
