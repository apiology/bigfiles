# frozen_string_literal: true

require 'spec_helper'
require 'bigfiles'

describe BigFiles::FileWithLines do
  let(:filename) { instance_double(String, 'filename') }
  let(:file_opener) { class_double(File, 'file_opener') }

  subject(:file_with_lines) do
    described_class.new(filename, file_opener: file_opener)
  end

  context 'with a filename' do
    describe '#new' do
      it 'initializes' do
        file_with_lines
      end
    end

    describe '#<=>' do
      let(:spaceship_result) { instance_double(Int, 'spaceship_result') }
      let(:another_filename) { instance_double(String, 'another_filename') }
      let(:another_file_with_lines) do
        described_class.new(another_filename, file_opener: file_opener)
      end

      def allow_num_lines_calls
        allow(file_with_lines).to(receive(:num_lines))
                              .and_return(1)
        allow(another_file_with_lines).to(receive(:num_lines))
                                      .and_return(2)
      end

      it 'is sortable' do
        allow_num_lines_calls
        expect(file_with_lines.<=>(another_file_with_lines))
          .to eq(-1)
      end
    end

    describe '#num_lines' do
      let(:opened_file) { instance_double(File, 'opened_file') }

      def allow_file_read
        allow(file_opener).to(receive(:open)).with(filename, 'r')
                          .and_yield(opened_file)
        allow(opened_file).to(receive(:each_line))
                          .and_yield('line 1').and_yield('line 2')
                          .and_yield('line 3')
      end

      it 'returns a number' do
        # file=File.open("path-to-file","r")
        # file.readlines.size
        allow_file_read
        expect(file_with_lines.num_lines).to eq(3)
      end
    end
  end
end
